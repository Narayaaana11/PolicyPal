import React from 'react';
import { Shield } from 'lucide-react';

export default function Footer({ onNavigate }) {
  return (
    <footer style={{ padding: '60px 0 30px 0', background: '#070d1e', borderTop: '1px solid rgba(255, 255, 255, 0.08)' }}>
      <div className="container">
        <div style={{ display: 'flex', justifyContent: 'space-between', flexWrap: 'wrap', gap: '32px', marginBottom: '40px' }}>
          <div>
            <div style={{ display: 'flex', alignItems: 'center', gap: '10px', fontSize: '20px', fontWeight: '800', marginBottom: '12px' }}>
              <Shield size={24} color="#0f52ba" />
              <span>PolicyPal</span>
            </div>
            <p style={{ color: '#94a3b8', fontSize: '14px', maxWidth: '300px' }}>
              Insurance Policy Comparison, Vault Management & Grounded AI Claims Guidance.
            </p>
          </div>

          <div>
            <h4 style={{ color: '#fff', fontSize: '15px', fontWeight: '600', marginBottom: '16px' }}>Platform</h4>
            <ul style={{ listStyle: 'none', display: 'flex', flexDirection: 'column', gap: '10px', fontSize: '14px', color: '#94a3b8' }}>
              <li><a href="#features">Features</a></li>
              <li><a href="#waitlist">Waitlist</a></li>
              <li><a href="#contact">Contact</a></li>
            </ul>
          </div>

          <div>
            <h4 style={{ color: '#fff', fontSize: '15px', fontWeight: '600', marginBottom: '16px' }}>Legal & Privacy</h4>
            <ul style={{ listStyle: 'none', display: 'flex', flexDirection: 'column', gap: '10px', fontSize: '14px', color: '#94a3b8' }}>
              <li><button onClick={() => onNavigate('privacy')} style={{ background: 'none', border: 'none', color: '#94a3b8', cursor: 'pointer', padding: 0, font: 'inherit' }}>Privacy Policy</button></li>
              <li><button onClick={() => onNavigate('terms')} style={{ background: 'none', border: 'none', color: '#94a3b8', cursor: 'pointer', padding: 0, font: 'inherit' }}>Terms of Service</button></li>
            </ul>
          </div>
        </div>

        <div style={{ textAlign: 'center', borderTop: '1px solid rgba(255, 255, 255, 0.05)', paddingTop: '24px', fontSize: '13px', color: '#64748b' }}>
          © {new Date().getFullYear()} PolicyPal Platform. All rights reserved.
        </div>
      </div>
    </footer>
  );
}
