"use client";
import React from 'react';
import { Sparkles, FileText, CheckCircle, AlertOctagon } from 'lucide-react';

export default function AiClaimsDemo() {
  return (
    <section id="ai-claims" className="py-24 bg-gradient-to-b from-[#001219] via-[#00222e] to-[#001219] border-t border-[rgba(10,147,150,0.15)] relative">
      <div className="max-w-7xl mx-auto px-6">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
          <div>
            <span className="badge-pearl mb-4 inline-block">Document-Grounded Intelligence</span>
            <h2 className="font-display text-4xl md:text-5xl font-extrabold text-white mb-6 leading-tight">
              Pre-Check Incidents with Grounded AI Guidance
            </h2>
            <p className="text-[#94d2bd] text-base md:text-lg mb-8 leading-relaxed">
              Upload incident photos and brief notes after an accident. Our document-grounded engine compares reported details against your stored policy text to highlight relevant clauses, document checklists, and watchout exclusions.
            </p>

            <div className="space-y-4">
              <div className="flex items-start gap-4 p-4 rounded-xl bg-[#001a24] border border-[#0a9396]/30">
                <FileText className="w-6 h-6 text-[#ee9b00] shrink-0 mt-1" />
                <div>
                  <h4 className="text-white font-bold text-base">Grounded to Exact Source Text</h4>
                  <p className="text-[#94d2bd] text-sm">Every clause citation links directly to your uploaded policy document text.</p>
                </div>
              </div>

              <div className="flex items-start gap-4 p-4 rounded-xl bg-[#001a24] border border-[#0a9396]/30">
                <CheckCircle className="w-6 h-6 text-[#00a86b] shrink-0 mt-1" />
                <div>
                  <h4 className="text-white font-bold text-base">Automated Document Checklist</h4>
                  <p className="text-[#94d2bd] text-sm">Generates exact list of receipts, reports, and photos required by your insurer.</p>
                </div>
              </div>
            </div>
          </div>

          {/* Interactive Mock Card */}
          <div className="luxury-glass p-8 relative">
            <div className="flex items-center justify-between pb-6 border-b border-[#0a9396]/30 mb-6">
              <div className="flex items-center gap-3">
                <Sparkles className="w-5 h-5 text-[#ee9b00]" />
                <span className="font-display font-bold text-white text-lg">AI Guidance Analysis</span>
              </div>
              <span className="text-xs font-mono px-3 py-1 rounded-full bg-[#005f73]/40 text-[#94d2bd] border border-[#0a9396]">
                GEICO AUTO #POL-998877
              </span>
            </div>

            <div className="space-y-4 mb-6">
              <div className="p-4 rounded-xl bg-[#001a24] border border-[#0a9396]/20 text-xs text-[#94d2bd]">
                <strong className="text-white block mb-1">Clause 4.1 (Collision Coverage):</strong>
                Protection applies for collision incidents reported within 14 days of occurrence.
              </div>

              <div className="p-4 rounded-xl bg-[#001a24] border border-[#0a9396]/20 text-xs text-[#94d2bd]">
                <strong className="text-white block mb-1">Required Checklist:</strong>
                • Police Incident Report &nbsp;&bull;&nbsp; Photo of bumper damage &nbsp;&bull;&nbsp; Repair Shop Estimate
              </div>
            </div>

            {/* MANDATORY DISCLAIMER BADGE */}
            <div className="p-4 rounded-xl bg-[#ae2012]/15 border border-[#ae2012]/40 text-xs text-[#e9d8a6] flex items-start gap-3">
              <AlertOctagon className="w-5 h-5 text-[#ee9b00] shrink-0" />
              <p className="leading-relaxed">
                <strong>DISCLAIMER:</strong> PolicyPal provides information for guidance purposes only and does not constitute a formal coverage decision or guarantee. Final claim authorization rests solely with your insurance provider.
              </p>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
