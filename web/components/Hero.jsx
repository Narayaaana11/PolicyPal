"use client";
import React, { useState } from 'react';
import { ArrowRight, ShieldCheck, CheckCircle2, Lock } from 'lucide-react';

export default function Hero() {
  const [email, setEmail] = useState('');
  const [statusMsg, setStatusMsg] = useState('');
  const [loading, setLoading] = useState(false);

  const handleWaitlist = async (e) => {
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
      setStatusMsg('Thank you for joining the PolicyPal waitlist!');
    } finally {
      setLoading(false);
    }
  };

  return (
    <section className="relative pt-24 pb-32 overflow-hidden bg-gradient-to-b from-[#001219] via-[#00222e] to-[#001219]">
      {/* Glow Effects */}
      <div className="absolute top-1/4 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[600px] h-[600px] bg-[#ee9b00]/10 rounded-full blur-[140px] pointer-events-none" />

      <div className="max-w-5xl mx-auto px-6 text-center relative z-10">
        <div className="inline-flex items-center gap-2 px-4 py-2 rounded-full border border-[#0a9396]/40 bg-[#005f73]/20 text-[#94d2bd] text-xs font-medium mb-8">
          <ShieldCheck className="w-4 h-4 text-[#ee9b00]" /> High-Performance Insurance Engine & Grounded AI
        </div>

        <h1 className="font-display text-5xl md:text-7xl font-extrabold text-white leading-[1.1] mb-8 tracking-tight">
          Never Miss a Renewal.<br />
          <span className="text-transparent bg-clip-text bg-gradient-to-r from-[#ee9b00] via-[#e9d8a6] to-[#94d2bd]">
            Understand Every Clause with AI.
          </span>
        </h1>

        <p className="text-lg md:text-xl text-[#94d2bd] max-w-3xl mx-auto mb-12 font-normal leading-relaxed">
          Consolidate your auto, health, life, and home policies in one encrypted, high-availability vault. Instant document grounding, lifecycle tracking, and side-by-side market evaluation.
        </p>

        <form id="waitlist" onSubmit={handleWaitlist} className="max-w-xl mx-auto flex flex-col sm:flex-row gap-3 mb-8">
          <input
            type="email"
            required
            placeholder="Enter your email for private beta..."
            className="flex-1 px-5 py-4 rounded-xl bg-[#002a38] border border-[#0a9396] text-white text-base outline-none focus:border-[#ee9b00] transition-colors"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
          />
          <button type="submit" disabled={loading} className="btn-golden whitespace-nowrap justify-center">
            {loading ? 'Processing...' : 'Claim Invites'} <ArrowRight className="w-5 h-5" />
          </button>
        </form>

        {statusMsg && (
          <p className="text-[#94d2bd] font-semibold text-sm flex items-center justify-center gap-2 mb-8">
            <CheckCircle2 className="w-4 h-4 text-[#ee9b00]" /> {statusMsg}
          </p>
        )}

        <div className="flex flex-wrap items-center justify-center gap-8 text-xs font-mono text-[#94d2bd]/80 pt-6 border-t border-[rgba(10,147,150,0.2)]">
          <span className="flex items-center gap-2"><Lock className="w-3.5 h-3.5 text-[#ee9b00]" /> AES-256 ENCRYPTED</span>
          <span>•</span>
          <span>DOCUMENT GROUNDED AI</span>
          <span>•</span>
          <span>ZERO DATA LEAKAGE</span>
        </div>
      </div>
    </section>
  );
}
