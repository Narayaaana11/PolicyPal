import React from 'react';
import { ArrowLeft } from 'lucide-react';

export default function TermsPage({ onBack }) {
  return (
    <div style={{ padding: '60px 0', minHeight: '80vh' }}>
      <div className="container" style={{ maxWidth: '800px' }}>
        <button onClick={onBack} className="btn-primary" style={{ background: 'transparent', border: '1px solid var(--border)', marginBottom: '32px' }}>
          <ArrowLeft size={16} /> Back to Home
        </button>

        <h1 style={{ fontSize: '36px', fontWeight: '800', marginBottom: '24px' }}>Terms of Service</h1>

        <div className="glass-card" style={{ display: 'flex', flexDirection: 'column', gap: '20px', lineHeight: '1.7', color: '#cbd5e1' }}>
          <p>
            Welcome to <strong>PolicyPal</strong>. By using our platform and mobile application, you agree to these Terms of Service.
          </p>

          <h3 style={{ color: '#fff', fontSize: '18px', fontWeight: '700' }}>1. Information & Guidance Tool Notice</h3>
          <p>
            PolicyPal is an information organization and claims assistance tool. PolicyPal does not provide formal legal or official insurance coverage verdicts. All claims assessments are informational pre-checks. Final claim authorization rests solely with your licensed insurance provider.
          </p>

          <h3 style={{ color: '#fff', fontSize: '18px', fontWeight: '700' }}>2. User Responsibilities</h3>
          <p>
            Users are responsible for reviewing auto-filled policy data for accuracy before saving records to their vault.
          </p>
        </div>
      </div>
    </div>
  );
}
