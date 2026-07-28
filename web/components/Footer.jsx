"use client";
import React from 'react';
import { Shield } from 'lucide-react';

export default function Footer() {
  return (
    <footer className="py-16 bg-[#000d12] border-t border-[rgba(10,147,150,0.2)] text-[#94d2bd] text-sm">
      <div className="max-w-7xl mx-auto px-6 flex flex-col md:flex-row justify-between items-center gap-8">
        <div className="flex items-center gap-3">
          <div className="w-8 h-8 rounded-lg bg-gradient-to-br from-[#ee9b00] to-[#ca6702] flex items-center justify-center">
            <Shield className="w-5 h-5 text-[#001219]" />
          </div>
          <span className="font-display text-xl font-bold text-white">PolicyPal</span>
        </div>

        <div className="flex gap-8 text-xs font-mono">
          <a href="#vault" className="hover:text-[#ee9b00] transition-colors">VAULT</a>
          <a href="#ai-claims" className="hover:text-[#ee9b00] transition-colors">GROUNDED AI</a>
          <a href="#compare" className="hover:text-[#ee9b00] transition-colors">COMPARISON</a>
          <a href="#contact" className="hover:text-[#ee9b00] transition-colors">CONTACT</a>
        </div>

        <p className="text-xs text-[#94d2bd]/60">
          © {new Date().getFullYear()} PolicyPal Infrastructure Inc. All rights reserved.
        </p>
      </div>
    </footer>
  );
}
