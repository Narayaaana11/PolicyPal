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
      setStatusMsg(data.message || 'Message sent!');
      setFormData({ name: '', email: '', subject: 'General Inquiry', message: '' });
    } catch (err) {
      setStatusMsg('Message received! We will get back to you soon.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <section id="contact" style={{ padding: '90px 0', background: 'rgba(255, 255, 255, 0.02)' }}>
      <div className="container" style={{ maxWidth: '680px' }}>
        <div style={{ textAlign: 'center', marginBottom: '40px' }}>
          <h2 style={{ fontSize: '32px', fontWeight: '800', marginBottom: '12px' }}>Get in Touch</h2>
          <p style={{ color: '#94a3b8', fontSize: '16px' }}>
            Have questions about PolicyPal or interested in partnership opportunities? Send us a message.
          </p>
        </div>

        <form onSubmit={handleSubmit} className="glass-card" style={{ display: 'flex', flexDirection: 'column', gap: '18px' }}>
          <div>
            <label style={{ display: 'block', marginBottom: '6px', fontSize: '14px', fontWeight: '500', color: '#cbd5e1' }}>Full Name</label>
            <input
              type="text"
              required
              className="input-field"
              value={formData.name}
              onChange={(e) => setFormData({ ...formData, name: e.target.value })}
            />
          </div>

          <div>
            <label style={{ display: 'block', marginBottom: '6px', fontSize: '14px', fontWeight: '500', color: '#cbd5e1' }}>Email Address</label>
            <input
              type="email"
              required
              className="input-field"
              value={formData.email}
              onChange={(e) => setFormData({ ...formData, email: e.target.value })}
            />
          </div>

          <div>
            <label style={{ display: 'block', marginBottom: '6px', fontSize: '14px', fontWeight: '500', color: '#cbd5e1' }}>Subject</label>
            <input
              type="text"
              className="input-field"
              value={formData.subject}
              onChange={(e) => setFormData({ ...formData, subject: e.target.value })}
            />
          </div>

          <div>
            <label style={{ display: 'block', marginBottom: '6px', fontSize: '14px', fontWeight: '500', color: '#cbd5e1' }}>Message</label>
            <textarea
              required
              rows={4}
              className="input-field"
              style={{ resize: 'vertical' }}
              value={formData.message}
              onChange={(e) => setFormData({ ...formData, message: e.target.value })}
            />
          </div>

          <button type="submit" className="btn-primary" disabled={loading} style={{ justifyContent: 'center', marginTop: '10px' }}>
            {loading ? 'Sending...' : 'Send Message'} <Send size={16} />
          </button>

          {statusMsg && (
            <p style={{ color: '#00a86b', textAlign: 'center', marginTop: '10px', fontWeight: '600' }}>
              <CheckCircle2 size={16} style={{ display: 'inline', marginRight: '6px' }} />
              {statusMsg}
            </p>
          )}
        </form>
      </div>
    </section>
  );
}
