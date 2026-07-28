import React from 'react';
import { ArrowLeft, Shield } from 'lucide-react';

export default function PrivacyPage({ onBack }) {
  return (
    <div style={{ padding: '60px 0', minHeight: '80vh' }}>
      <div className="container" style={{ maxWidth: '800px' }}>
        <button onClick={onBack} className="btn-primary" style={{ background: 'transparent', border: '1px solid var(--border)', marginBottom: '32px' }}>
          <ArrowLeft size={16} /> Back to Home
        </button>

        <h1 style={{ fontSize: '36px', fontWeight: '800', marginBottom: '24px' }}>Privacy Policy & Data Security</h1>

        <div className="glass-card" style={{ display: 'flex', flexDirection: 'column', gap: '20px', lineHeight: '1.7', color: '#cbd5e1' }}>
          <p>
            At <strong>PolicyPal</strong>, protecting your data privacy and securing sensitive insurance document records is our highest priority.
          </p>

          <h3 style={{ color: '#fff', fontSize: '18px', fontWeight: '700' }}>1. Data Encryption & Storage</h3>
          <p>
            All user policy records, uploaded PDFs, and incident details are encrypted both in transit (TLS 1.3/HTTPS) and at rest (AES-256 cloud storage). We never store raw binary files directly in application databases.
          </p>

          <h3 style={{ color: '#fff', fontSize: '18px', fontWeight: '700' }}>2. AI Grounding & Privacy</h3>
          <p>
            Our AI claims guidance layer operates strictly using document-grounded processing against your specific policy text. Your policy documents are never used to train global public language models.
          </p>

          <h3 style={{ color: '#fff', fontSize: '18px', fontWeight: '700' }}>3. Right-to-Erasure (GDPR & Data Deletion)</h3>
          <p>
            You retain full ownership of your data. You may request account deletion directly from the mobile app or via our support channel, resulting in the permanent hard deletion of all associated policies and claim histories.
          </p>
        </div>
      </div>
    </div>
  );
}
