import React from 'react';
import { Shield } from 'lucide-react';

export default function Navbar() {
  return (
    <nav style={{
      padding: '24px 0',
      borderBottom: '1px solid rgba(255, 255, 255, 0.1)',
      position: 'sticky',
      top: 0,
      background: 'rgba(11, 19, 43, 0.85)',
      backdropFilter: 'blur(10px)',
      zIndex: 100
    }}>
      <div className="container" style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: '10px', fontSize: '22px', fontWeight: '800', color: '#fff' }}>
          <Shield size={28} color="#0f52ba" />
          <span>Policy<span style={{ color: '#0f52ba' }}>Pal</span></span>
        </div>
        <div style={{ display: 'flex', gap: '24px', alignItems: 'center' }}>
          <a href="#features" style={{ color: '#94a3b8', fontSize: '15px', fontWeight: '500' }}>Features</a>
          <a href="#how-it-works" style={{ color: '#94a3b8', fontSize: '15px', fontWeight: '500' }}>How it Works</a>
          <a href="#contact" style={{ color: '#94a3b8', fontSize: '15px', fontWeight: '500' }}>Contact</a>
          <a href="#waitlist" className="btn-primary" style={{ padding: '10px 20px', fontSize: '14px' }}>Join Waitlist</a>
        </div>
      </div>
    </nav>
  );
}
