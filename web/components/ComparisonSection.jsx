"use client";
import React, { useState } from 'react';
import { Scale, Check, Zap } from 'lucide-react';

export default function ComparisonSection() {
  const [activeTab, setActiveTab] = useState('auto');

  const plans = {
    auto: [
      { name: 'Progressive Shield', price: '$980 / yr', limit: '$250,000', score: 88, features: ['24/7 Roadside Assistance', 'Rental Reimbursement', 'Zero Glass Deductible'] },
      { name: 'Geico Gold Direct', price: '$1,100 / yr', limit: '$300,000', score: 92, features: ['Accident Forgiveness', 'New Car Replacement', 'Towing Support'] },
      { name: 'State Farm Premier', price: '$1,050 / yr', limit: '$250,000', score: 85, features: ['Telematics Discount', 'Rideshare Coverage', 'Emergency Locksmith'] }
    ],
    health: [
      { name: 'BlueCross Preferred PPO', price: '$3,400 / yr', limit: '$1,000,000', score: 90, features: ['Zero Copay Preventative Care', 'Global Emergency Coverage', 'Mental Health In-Network'] },
      { name: 'UnitedHealthcare Choice', price: '$2,950 / yr', limit: '$750,000', score: 86, features: ['Virtual Visits $0', 'Prescription Tier 1 Included', 'Wellness Rewards'] }
    ]
  };

  const currentPlans = plans[activeTab] || plans['auto'];

  return (
    <section id="compare" className="py-24 bg-[#001219] border-t border-[rgba(10,147,150,0.15)] relative">
      <div className="max-w-7xl mx-auto px-6">
        <div className="text-center max-w-3xl mx-auto mb-16">
          <span className="badge-pearl mb-4 inline-block">Real-Time Market Intelligence</span>
          <h2 className="font-display text-4xl md:text-5xl font-extrabold text-white mb-6">
            Side-by-Side Policy Comparison Engine
          </h2>
          <p className="text-[#94d2bd] text-base md:text-lg">
            Evaluate alternative insurance plans on premium rates, coverage caps, and computed value scores.
          </p>
        </div>

        {/* Tab Selection */}
        <div className="flex justify-center gap-3 mb-12">
          {['auto', 'health'].map((tab) => (
            <button
              key={tab}
              onClick={() => setActiveTab(tab)}
              className={`px-6 py-3 rounded-xl font-bold text-sm transition-all ${
                activeTab === tab
                  ? 'bg-gradient-to-r from-[#ee9b00] to-[#ca6702] text-[#001219] shadow-lg'
                  : 'bg-[#00222e] text-[#94d2bd] border border-[#0a9396]/30 hover:border-[#ee9b00]'
              }`}
            >
              {tab.toUpperCase()} COVERAGE
            </button>
          ))}
        </div>

        {/* Comparison Cards Grid */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          {currentPlans.map((plan, idx) => (
            <div key={idx} className="luxury-glass p-8 flex flex-col justify-between relative">
              <div>
                <div className="flex justify-between items-start mb-4">
                  <h3 className="font-display text-xl font-bold text-white">{plan.name}</h3>
                  <span className="px-3 py-1 rounded-full bg-[#00a86b]/15 text-[#00a86b] border border-[#00a86b]/30 text-xs font-bold flex items-center gap-1">
                    <Zap className="w-3 h-3" /> Score {plan.score}/100
                  </span>
                </div>

                <div className="text-3xl font-extrabold font-mono text-[#ee9b00] mb-2">{plan.price}</div>
                <div className="text-xs text-[#94d2bd] mb-6">Coverage Cap: <strong className="text-white">{plan.limit}</strong></div>

                <div className="space-y-3 border-t border-[#0a9396]/20 pt-6">
                  {plan.features.map((f, fIdx) => (
                    <div key={fIdx} className="flex items-center gap-3 text-xs text-[#94d2bd]">
                      <Check className="w-4 h-4 text-[#00a86b] shrink-0" />
                      <span>{f}</span>
                    </div>
                  ))}
                </div>
              </div>

              <button className="w-full mt-8 btn-golden text-xs justify-center">
                Compare Against My Policy
              </button>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
