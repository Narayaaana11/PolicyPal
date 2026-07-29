const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const User = require('./src/models/User');
const Policy = require('./src/models/Policy');
const Notification = require('./src/models/Notification');
const config = require('./src/config/env');

async function seedData() {
  try {
    console.log('Connecting to MongoDB...');
    await mongoose.connect(config.mongodbUri);
    console.log('Connected.');

    // Clear existing
    await User.deleteMany({ email: 'testuser@policypal.com' });
    
    // Create User
    const passwordHash = await bcrypt.hash('Password123!', 10);
    const user = await User.create({
      name: 'Test User',
      email: 'testuser@policypal.com',
      passwordHash: passwordHash,
      phone: '9876543210',
    });
    console.log('User created:', user.email);

    // Clear existing dummy policies for this user just in case
    await Policy.deleteMany({ userId: user._id });

    // Create Policies
    const policies = await Policy.insertMany([
      {
        userId: user._id,
        type: 'health',
        provider: 'Star Health & Allied Insurance',
        policyNumber: 'HLT-12345678',
        premiumAmount: 15000,
        premiumCadence: 'yearly',
        startDate: new Date('2023-01-15'),
        endDate: new Date('2024-01-14'),
        coverageSummary: 'Comprehensive Health Insurance with ₹5 Lakhs Sum Insured. Covers pre and post hospitalization.',
        status: 'active',
        nominee: 'Spouse',
      },
      {
        userId: user._id,
        type: 'auto',
        provider: 'ICICI Lombard',
        policyNumber: 'MOT-87654321',
        premiumAmount: 12000,
        premiumCadence: 'yearly',
        startDate: new Date('2023-06-01'),
        endDate: new Date('2024-05-31'),
        coverageSummary: 'Comprehensive Motor Insurance with Zero Depreciation. IDV: ₹6 Lakhs.',
        status: 'active',
      }
    ]);
    console.log(`Created ${policies.length} policies.`);

    // Add a dummy notification
    await Notification.deleteMany({ userId: user._id });
    await Notification.create({
      userId: user._id,
      title: 'Welcome to PolicyPal!',
      message: 'Your account has been seeded with test data.',
      type: 'system',
      read: false
    });

    console.log('Seeding complete!');
    process.exit(0);
  } catch (error) {
    console.error('Seeding error:', error);
    process.exit(1);
  }
}

seedData();
