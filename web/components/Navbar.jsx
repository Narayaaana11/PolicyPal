"use client";
import React from 'react';
import { Shield, Sparkles } from 'lucide-react';

export default function Navbar() {
  return (
    <nav className="sticky top-0 z-50 py-5 border-b border-[rgba(10,147,150,0.2)] bg-[#001219]/80 backdrop-blur-md">
      <div className="max-w-7xl mx-auto px-6 flex justify-between items-center">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-[#ee9b00] to-[#ca6702] flex items-center justify-center shadow-lg">
            <Shield className="w-6 h-6 text-[#001219]" />
          </div>
          <span className="font-display text-2xl font-extrabold tracking-tight text-white">
            Policy<span className="text-[#ee9b00]">Pal</span>
          </span>
        </div>

        <div className="hidden md:flex items-center gap-8 text-sm font-medium text-[#94d2bd]">
          <a href="#vault" className="hover:text-[#e9d8a6] transition-colors">Vault Engine</a>
          <a href="#ai-claims" className="hover:text-[#e9d8a6] transition-colors">AI Guidance</a>
          <a href="#compare" className="hover:text-[#e9d8a6] transition-colors">Comparison</a>
          <a href="#contact" className="hover:text-[#e9d8a6] transition-colors">Contact</a>
        </div>

        <a href="#waitlist" className="btn-golden text-sm">
          <Sparkles className="w-4 h-4" /> Get Early Access
        </a>
      </div>
    </nav>
  );
}
