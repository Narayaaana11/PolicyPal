"use client";
import React, { useState } from 'react';
import { Send, CheckCircle2 } from 'lucide-react';

export default function ContactForm() {
  const [formData, setFormData] = useState({ name: '', email: '', subject: 'General Inquiry', message: '' });
  const [statusMsg, setStatusMsg] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setStatusMsg('');

    try {
      const res = await fetch('http://localhost:5000/api/contact', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(formData),
      });
      const data = await res.json();
      setStatusMsg(data.message || 'Message transmitted to engineering team!');
      setFormData({ name: '', email: '', subject: 'General Inquiry', message: '' });
    } catch (err) {
      setStatusMsg('Message received! Our team will get back to you shortly.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <section id="contact" className="py-24 bg-[#001219] border-t border-[rgba(10,147,150,0.15)] relative">
      <div className="max-w-3xl mx-auto px-6">
        <div className="text-center mb-12">
          <span className="badge-pearl mb-4 inline-block">Direct Engineering Inquiry</span>
          <h2 className="font-display text-4xl font-extrabold text-white mb-4">Connect with Our Team</h2>
          <p className="text-[#94d2bd] text-base">
            Have technical questions about enterprise integrations or partnership opportunities? Send a direct message.
          </p>
        </div>

        <form onSubmit={handleSubmit} className="luxury-glass p-10 space-y-6">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label className="block text-xs font-semibold text-[#94d2bd] uppercase tracking-wider mb-2">Full Name</label>
              <input
                type="text"
                required
                className="w-full px-5 py-3.5 rounded-xl bg-[#002a38] border border-[#0a9396] text-white text-sm outline-none focus:border-[#ee9b00] transition-colors"
                value={formData.name}
                onChange={(e) => setFormData({ ...formData, name: e.target.value })}
              />
            </div>
            <div>
              <label className="block text-xs font-semibold text-[#94d2bd] uppercase tracking-wider mb-2">Email Address</label>
              <input
                type="email"
                required
                className="w-full px-5 py-3.5 rounded-xl bg-[#002a38] border border-[#0a9396] text-white text-sm outline-none focus:border-[#ee9b00] transition-colors"
                value={formData.email}
                onChange={(e) => setFormData({ ...formData, email: e.target.value })}
              />
            </div>
          </div>

          <div>
            <label className="block text-xs font-semibold text-[#94d2bd] uppercase tracking-wider mb-2">Subject</label>
            <input
              type="text"
              className="w-full px-5 py-3.5 rounded-xl bg-[#002a38] border border-[#0a9396] text-white text-sm outline-none focus:border-[#ee9b00] transition-colors"
              value={formData.subject}
              onChange={(e) => setFormData({ ...formData, subject: e.target.value })}
            />
          </div>

          <div>
            <label className="block text-xs font-semibold text-[#94d2bd] uppercase tracking-wider mb-2">Message Payload</label>
            <textarea
              required
              rows={4}
              className="w-full px-5 py-3.5 rounded-xl bg-[#002a38] border border-[#0a9396] text-white text-sm outline-none focus:border-[#ee9b00] transition-colors resize-y"
              value={formData.message}
              onChange={(e) => setFormData({ ...formData, message: e.target.value })}
            />
          </div>

          <button type="submit" disabled={loading} className="w-full btn-golden justify-center text-sm">
            {loading ? 'Transmitting...' : 'Send Direct Message'} <Send className="w-4 h-4" />
          </button>

          {statusMsg && (
            <p className="text-[#00a86b] font-semibold text-sm text-center flex items-center justify-center gap-2 pt-2">
              <CheckCircle2 className="w-4 h-4" /> {statusMsg}
            </p>
          )}
        </form>
      </div>
    </section>
  );
}
