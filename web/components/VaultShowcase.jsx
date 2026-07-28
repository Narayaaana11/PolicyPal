"use client";
import React from 'react';
import { FolderLock, AlertTriangle, Shield, Layers } from 'lucide-react';

export default function VaultShowcase() {
  const features = [
    {
      icon: <FolderLock className="w-8 h-8 text-[#ee9b00]" />,
      title: 'Unified Multi-Policy Vault',
      desc: 'Consolidate auto, health, life, and home policies in one encrypted storage layer. Instant search across coverage summaries and policy numbers.'
    },
    {
      icon: <AlertTriangle className="w-8 h-8 text-[#bb3e03]" />,
      title: 'Overlap Detection Engine',
      desc: 'Automatic analysis scans active policy portfolio to detect redundant risk coverage, preventing duplicate premium payments.'
    },
    {
      icon: <Shield className="w-8 h-8 text-[#94d2bd]" />,
      title: 'Lifecycle Reminders',
      desc: 'Proactive payment and renewal alerts schedule push notifications ahead of expiration dates to eliminate lapsed coverage.'
    },
    {
      icon: <Layers className="w-8 h-8 text-[#0a9396]" />,
      title: 'Family & Group Profiles',
      desc: 'Manage dependent policies under a unified account structure with granular view and edit permission controls.'
    }
  ];

  return (
    <section id="vault" className="py-24 bg-[#001219] border-t border-[rgba(10,147,150,0.15)] relative">
      <div className="max-w-7xl mx-auto px-6">
        <div className="text-center max-w-3xl mx-auto mb-16">
          <span className="badge-pearl mb-4 inline-block">High-Performance Vault Architecture</span>
          <h2 className="font-display text-4xl md:text-5xl font-extrabold text-white mb-6">
            Institutional-Grade Policy Organization
          </h2>
          <p className="text-base md:text-lg text-[#94d2bd]">
            Built with zero-trust data protection and high-speed query indexing.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
          {features.map((item, idx) => (
            <div key={idx} className="luxury-glass p-8 relative overflow-hidden group">
              <div className="p-3 w-fit rounded-xl bg-[#001a24] border border-[#0a9396]/30 mb-6 group-hover:border-[#ee9b00] transition-colors">
                {item.icon}
              </div>
              <h3 className="font-display text-2xl font-bold text-white mb-3">{item.title}</h3>
              <p className="text-[#94d2bd] text-sm md:text-base leading-relaxed">{item.desc}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
