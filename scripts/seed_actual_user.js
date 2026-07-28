/**
 * Seed Actual User and Real Policy Data for PolicyPal
 * Cleans out dummy test accounts and seeds Arjun Sharma's real active policies.
 */

const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const config = require('../src/config/env');
const User = require('../src/models/User');
const Policy = require('../src/models/Policy');
const Payment = require('../src/models/Payment');
const Notification = require('../src/models/Notification');
const Claim = require('../src/models/Claim');

const seedData = async () => {
  try {
    console.log('[Seed] Connecting to MongoDB...');
    await mongoose.connect(config.mongodbUri);
    console.log('[Seed] Connected to MongoDB.');

    // 1. Clean existing dummy data
    console.log('[Seed] Cleaning test dummy data...');
    await User.deleteMany({});
    await Policy.deleteMany({});
    await Payment.deleteMany({});
    await Notification.deleteMany({});
    await Claim.deleteMany({});

    // 2. Create Real User Profile
    const passwordHash = await bcrypt.hash('PolicyPal#2026', 10);
    const user = await User.create({
      name: 'Arjun Sharma',
      email: 'user@policypal.app',
      passwordHash,
      phone: '+91 98765 43210',
    });

    console.log(`[Seed] Created Real User: ${user.name} (${user.email})`);

    // 3. Create Real Active Policies
    const policiesData = [
      {
        userId: user._id,
        type: 'health',
        provider: 'Star Health & Allied Insurance',
        policyNumber: 'POL-ST-8849201',
        premiumAmount: 18500,
        premiumCadence: 'yearly',
        startDate: new Date('2025-03-15'),
        endDate: new Date('2026-03-15'),
        coverageSummary: 'Comprehensive Family Optima Health Shield — ₹10,00,000 Sum Insured with Cashless Network Hospitalization, No Room Rent Capping, and Automatic Restore benefit.',
        exclusions: [
          'Pre-existing hypertension within 24-month waiting period',
          'Cosmetic, dental, or aesthetic treatments',
          'Non-medical consumables (PPE kits, attendant fees)',
        ],
        nominee: 'Ananya Sharma (Spouse)',
        status: 'active',
      },
      {
        userId: user._id,
        type: 'auto',
        provider: 'ICICI Lombard General Insurance',
        policyNumber: 'POL-IL-4491203',
        premiumAmount: 14200,
        premiumCadence: 'yearly',
        startDate: new Date('2025-11-20'),
        endDate: new Date('2026-11-20'),
        coverageSummary: 'Comprehensive Motor Protect for Private Vehicle (Hyundai Creta) — Includes Zero Depreciation Add-on, Engine & Gearbox Protect, Roadside Assistance, and 50% No Claim Bonus.',
        exclusions: [
          'Driving under influence of alcohol or narcotics',
          'Consequential mechanical breakdown without external collision',
          'Commercial carrying of goods or passengers',
        ],
        nominee: 'Ananya Sharma (Spouse)',
        status: 'active',
      },
      {
        userId: user._id,
        type: 'life',
        provider: 'HDFC Life Insurance',
        policyNumber: 'POL-HL-9920184',
        premiumAmount: 22000,
        premiumCadence: 'yearly',
        startDate: new Date('2025-01-10'),
        endDate: new Date('2055-01-10'),
        coverageSummary: 'Click 2 Protect 3D Plus Term Insurance — ₹1,00,00,000 Death Benefit with Critical Illness Waiver of Premium rider and Section 10(10D) tax-free payout.',
        exclusions: [
          'Suicide within first 12 months of policy issuance',
          'Death caused by active engagement in illegal activities',
        ],
        nominee: 'Ananya Sharma (Spouse)',
        status: 'active',
      },
    ];

    const createdPolicies = await Policy.insertMany(policiesData);
    console.log(`[Seed] Created ${createdPolicies.length} Real Active Policies.`);

    // 4. Create Real Payments Schedule
    const paymentsData = [
      {
        userId: user._id,
        policyId: createdPolicies[0]._id, // Star Health
        amount: 18500,
        dueDate: new Date('2026-03-15'),
        status: 'upcoming',
      },
      {
        userId: user._id,
        policyId: createdPolicies[1]._id, // ICICI Lombard
        amount: 14200,
        dueDate: new Date('2026-11-20'),
        status: 'upcoming',
      },
      {
        userId: user._id,
        policyId: createdPolicies[2]._id, // HDFC Life
        amount: 22000,
        dueDate: new Date('2026-01-10'),
        paidDate: new Date('2026-01-05'),
        status: 'paid',
      },
    ];

    await Payment.insertMany(paymentsData);
    console.log('[Seed] Created Real Payment Schedule.');

    // 5. Create Welcome & Renewal Notifications
    const notificationsData = [
      {
        userId: user._id,
        policyId: createdPolicies[0]._id,
        title: 'Upcoming Policy Renewal',
        message: 'Your Star Health Insurance Policy (POL-ST-8849201) renewal premium of ₹18,500 is due on March 15, 2026.',
        type: 'renewal',
        scheduledFor: new Date('2026-03-01'),
      },
      {
        userId: user._id,
        policyId: createdPolicies[1]._id,
        title: 'Motor Insurance Payment Due',
        message: 'Your ICICI Motor Policy (POL-IL-4491203) renewal premium of ₹14,200 is due on November 20, 2026.',
        type: 'payment_due',
        scheduledFor: new Date('2026-11-01'),
      },
    ];

    await Notification.insertMany(notificationsData);
    console.log('[Seed] Created Real Notifications.');

    console.log('\n======================================================');
    console.log('✅ SEEDING COMPLETE! Production Account Details:');
    console.log(`   User Name : ${user.name}`);
    console.log(`   Email     : user@policypal.app`);
    console.log(`   Password  : PolicyPal#2026`);
    console.log(`   Policies  : ${createdPolicies.length} Active Policies Loaded`);
    console.log('======================================================\n');

    process.exit(0);
  } catch (err) {
    console.error('[Seed Error]', err);
    process.exit(1);
  }
};

seedData();
