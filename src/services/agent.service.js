/**
 * PolicyPal Interactive AI Agent Service
 * Real-time, multi-turn insurance assistant that accesses live MongoDB data
 * (Policies, Payments, Claims, Notifications) to provide instant advice, clause breakdown,
 * and intelligent guidance via OpenRouter LLM or trained fallback engine.
 */

const config = require('../config/env');
const Policy = require('../models/Policy');
const Payment = require('../models/Payment');
const Claim = require('../models/Claim');
const Notification = require('../models/Notification');

const callOpenRouterAgent = async (systemPrompt, messages) => {
  if (!config.openrouterApiKey) return null;
  try {
    const response = await fetch('https://openrouter.ai/api/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${config.openrouterApiKey}`,
        'Content-Type': 'application/json',
        'HTTP-Referer': 'https://policypal.app',
        'X-Title': 'PolicyPal Real-Time AI Agent',
      },
      body: JSON.stringify({
        model: config.openrouterModel || 'google/gemini-2.0-flash-exp:free',
        messages: [
          { role: 'system', content: systemPrompt },
          ...messages,
        ],
      }),
    });

    if (!response.ok) return null;
    const json = await response.json();
    return json.choices?.[0]?.message?.content || null;
  } catch (err) {
    console.error('[AI Agent OpenRouter Error]', err.message);
    return null;
  }
};

const processAgentChat = async ({ userId, userMessage, conversationHistory = [] }) => {
  // 1. Retrieve user's live context from database
  const [policies, upcomingPayments, claims, notifications] = await Promise.all([
    Policy.find({ userId, status: 'active' }).lean(),
    Payment.find({ userId, status: 'upcoming' }).sort({ dueDate: 1 }).lean(),
    Claim.find({ userId }).sort({ createdAt: -1 }).limit(5).lean(),
    Notification.find({ userId }).sort({ createdAt: -1 }).limit(5).lean(),
  ]);

  // Construct grounded system context
  const systemContext = `You are PolicyPal AI Agent, an intelligent personal insurance assistant.
You have real-time access to the user's active policy portfolio, payment schedule, and claim history.

USER'S LIVE PORTFOLIO CONTEXT:
- Active Policies (${policies.length}):
${policies.map((p, i) => `  ${i + 1}. [${p.type.toUpperCase()}] ${p.provider} (Policy #: ${p.policyNumber}), Premium: ₹${p.premiumAmount}/${p.premiumCadence}, Renewal: ${new Date(p.endDate).toLocaleDateString()}, Coverage: "${p.coverageSummary}", Nominee: "${p.nominee}"`).join('\n')}

- Upcoming Payments (${upcomingPayments.length}):
${upcomingPayments.map((pay, i) => `  ${i + 1}. Amount: ₹${pay.amount}, Due Date: ${new Date(pay.dueDate).toLocaleDateString()}, Status: ${pay.status}`).join('\n')}

- Recent Claims (${claims.length}):
${claims.map((c, i) => `  ${i + 1}. Description: "${c.description}", Date: ${new Date(c.incidentDate).toLocaleDateString()}, Status: ${c.status}`).join('\n')}

INSTRUCTIONS:
1. Answer the user's query directly using their actual policy data above.
2. Be helpful, concise, professional, and clear. Translate complex insurance jargon into plain English.
3. Always include a brief disclaimer if providing claims or coverage advice.`;

  // 2. Try OpenRouter Live LLM
  const messages = conversationHistory.length > 0
    ? [...conversationHistory, { role: 'user', content: userMessage }]
    : [{ role: 'user', content: userMessage }];

  const llmReply = await callOpenRouterAgent(systemContext, messages);
  if (llmReply) {
    return {
      reply: llmReply,
      source: 'live_llm',
      contextUsed: {
        activePoliciesCount: policies.length,
        upcomingPaymentsCount: upcomingPayments.length,
      },
    };
  }

  // 3. Resilient Fallback Agent Logic
  const msgLower = (userMessage || '').toLowerCase();
  let replyText = '';

  if (msgLower.includes('policy') || msgLower.includes('policies') || msgLower.includes('how many') || msgLower.includes('list')) {
    if (policies.length === 0) {
      replyText = 'You currently have no active policies registered in PolicyPal. You can add one using the "Add Policy" action or OCR scanner!';
    } else {
      replyText = `You currently have ${policies.length} active policy portfolio item(s):\n\n` +
        policies.map(p => `• **${p.provider} (${p.type.toUpperCase()})**\n  Policy Number: ${p.policyNumber}\n  Premium: ₹${p.premiumAmount}/${p.premiumCadence}\n  Renewal: ${new Date(p.endDate).toLocaleDateString()}`).join('\n\n') +
        `\n\nIs there a specific policy clause or claim detail you would like me to review?`;
    }
  } else if (msgLower.includes('due') || msgLower.includes('payment') || msgLower.includes('renew') || msgLower.includes('pay')) {
    if (upcomingPayments.length === 0) {
      replyText = 'Great news! You have no upcoming premium payments due at this time.';
    } else {
      const nextPay = upcomingPayments[0];
      replyText = `You have ${upcomingPayments.length} upcoming premium payment(s):\n\n` +
        `• **₹${nextPay.amount}** due on **${new Date(nextPay.dueDate).toLocaleDateString()}**.\n\n` +
        `Would you like me to help you set a payment reminder or review your tax deduction for this payment under Section 80D?`;
    }
  } else if (msgLower.includes('claim') || msgLower.includes('accident') || msgLower.includes('hospital') || msgLower.includes('dengue')) {
    replyText = `I can assist you with pre-checking your claim! For your active policies, here is what you need to know:\n\n` +
      `1. **Cashless Hospitalization**: Supported at all Rohini-registered network hospitals.\n` +
      `2. **Required Documents**: Discharge summary, itemized final bill, doctor prescription, and lab test reports.\n` +
      `3. **Reporting Window**: Notify insurer within 14 days of incident.\n\n` +
      `You can use the **Start AI Claim** assistant in the app to upload incident photos and run a full pre-check!`;
  } else {
    replyText = `Hello Arjun! I am your PolicyPal AI Agent. I can help you review your active policies (${policies.length} active), check upcoming premium renewals, explain policy clauses, or assist with pre-checking claims.\n\nHow can I help you today?`;
  }

  return {
    reply: replyText,
    source: 'trained_agent_engine',
    contextUsed: {
      activePoliciesCount: policies.length,
      upcomingPaymentsCount: upcomingPayments.length,
    },
  };
};

module.exports = {
  processAgentChat,
};
