import React from 'react';
import { FolderLock, Sparkles, BellRing, Scale } from 'lucide-react';

export default function Features() {
  const featuresList = [
    {
      icon: <FolderLock size={32} color="#0f52ba" />,
      title: 'Unified Policy Vault',
      desc: 'Store auto, health, life, and home policies in one encrypted location. Access coverage details anywhere.'
    },
    {
      icon: <Sparkles size={32} color="#00a86b" />,
      title: 'AI Claims Assistant',
      desc: 'Upload incident photos and notes. Get immediate, document-grounded guidance on clauses and document checklists.'
    },
    {
      icon: <BellRing size={32} color="#f59e0b" />,
      title: 'Lifecycle Reminders',
      desc: 'Smart notifications prevent lapsed coverage. Track payment due dates and upcoming renewal deadlines automatically.'
    },
    {
      icon: <Scale size={32} color="#8b5cf6" />,
      title: 'Comparison Engine',
      desc: 'Side-by-side comparison across providers on premium, coverage limits, and calculated value scores.'
    }
  ];

  return (
    <section id="features" style={{ padding: '90px 0', background: '#0b132b' }}>
      <div className="container">
        <div style={{ textAlign: 'center', marginBottom: '60px' }}>
          <h2 style={{ fontSize: '36px', fontWeight: '800', marginBottom: '16px' }}>Built for Modern Policyholders</h2>
          <p style={{ color: '#94a3b8', fontSize: '18px', maxWidth: '650px', margin: '0 auto' }}>
            Take control of your insurance coverage with intelligent management features.
          </p>
        </div>

        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(260px, 1fr))', gap: '28px' }}>
          {featuresList.map((item, idx) => (
            <div key={idx} className="glass-card">
              <div style={{ marginBottom: '20px' }}>{item.icon}</div>
              <h3 style={{ fontSize: '20px', fontWeight: '700', marginBottom: '12px', color: '#fff' }}>{item.title}</h3>
              <p style={{ color: '#94a3b8', fontSize: '15px', lineHeight: '1.6' }}>{item.desc}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
