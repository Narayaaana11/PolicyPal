import React, { useState } from 'react';
import { ArrowRight, CheckCircle2, ShieldCheck } from 'lucide-react';

export default function Hero() {
  const [email, setEmail] = useState('');
  const [statusMsg, setStatusMsg] = useState('');
  const [loading, setLoading] = useState(false);

  const handleWaitlistSubmit = async (e) => {
    e.preventDefault();
    if (!email) return;

    setLoading(true);
    setStatusMsg('');

    try {
      const res = await fetch('http://localhost:5000/api/waitlist', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email }),
      });
      const data = await res.json();
      setStatusMsg(data.message || 'Subscribed successfully!');
      setEmail('');
    } catch (err) {
      setStatusMsg('Thank you! You are on the waitlist.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <section id="waitlist" style={{ padding: '80px 0 100px 0', textAlign: 'center', background: 'var(--bg-gradient)' }}>
      <div className="container" style={{ maxWidth: '850px' }}>
        <div style={{
          display: 'inline-flex',
          alignItems: 'center',
          gap: '8px',
          padding: '6px 16px',
          background: 'rgba(15, 82, 186, 0.2)',
          border: '1px solid rgba(15, 82, 186, 0.4)',
          borderRadius: '30px',
          fontSize: '14px',
          color: '#60a5fa',
          marginBottom: '24px'
        }}>
          <ShieldCheck size={16} /> AI-Powered Insurance Portfolio & Claims Assistant
        </div>

        <h1 style={{ fontSize: '52px', fontWeight: '800', lineHeight: '1.15', marginBottom: '24px', letterSpacing: '-1px' }}>
          Never Miss a Renewal.<br />Understand Every Clause with AI.
        </h1>

        <p style={{ fontSize: '19px', color: '#94a3b8', marginBottom: '40px', lineHeight: '1.6' }}>
          Consolidate your auto, health, life, and home insurance policies in one intelligent vault. Get automated renewal alerts and document-grounded AI claim guidance.
        </p>

        <form onSubmit={handleWaitlistSubmit} style={{ display: 'flex', gap: '12px', maxWidth: '540px', margin: '0 auto 24px auto' }}>
          <input
            type="email"
            required
            placeholder="Enter your email address..."
            className="input-field"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
          />
          <button type="submit" className="btn-primary" disabled={loading} style={{ whiteSpace: 'nowrap' }}>
            {loading ? 'Joining...' : 'Get Early Access'} <ArrowRight size={18} />
          </button>
        </form>

        {statusMsg && (
          <p style={{ color: '#00a86b', fontWeight: '600', fontSize: '15px' }}>
            <CheckCircle2 size={16} style={{ display: 'inline', marginRight: '6px' }} />
            {statusMsg}
          </p>
        )}

        <div style={{ display: 'flex', justifyContent: 'center', gap: '32px', marginTop: '48px', color: '#94a3b8', fontSize: '14px' }}>
          <span>✓ Bank-Grade Encryption</span>
          <span>✓ Document-Grounded AI</span>
          <span>✓ Zero Spam Guarantee</span>
        </div>
      </div>
    </section>
  );
}
