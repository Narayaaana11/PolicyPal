const Policy = require('../models/Policy');

const getComparisonDataset = async (req, res, next) => {
  try {
    const { type = 'auto' } = req.query;

    // Fetch user's existing policies of this type
    const userPolicies = await Policy.find({
      userId: req.user._id,
      type,
    });

    // Market plans dataset for comparison engine
    const marketDataset = {
      auto: [
        {
          provider: 'Progressive Shield',
          planName: 'Auto Comprehensive Plus',
          premiumAmount: 980,
          premiumCadence: 'yearly',
          coverageLimit: 250000,
          deductible: 500,
          features: ['24/7 Roadside Assistance', 'Rental Car Reimbursement', 'Zero Glass Deductible'],
          valueScore: 88,
        },
        {
          provider: 'Geico Direct',
          planName: 'Auto Gold Protection',
          premiumAmount: 1100,
          premiumCadence: 'yearly',
          coverageLimit: 300000,
          deductible: 250,
          features: ['Accident Forgiveness', 'New Car Replacement', 'Towing Support'],
          valueScore: 92,
        },
        {
          provider: 'State Farm Premier',
          planName: 'Drive Safe & Save Auto',
          premiumAmount: 1050,
          premiumCadence: 'yearly',
          coverageLimit: 250000,
          deductible: 500,
          features: ['Telematics Discount', 'Rideshare Coverage', 'Emergency Locksmith'],
          valueScore: 85,
        },
      ],
      health: [
        {
          provider: 'BlueCross BlueShield',
          planName: 'Gold Preferred PPO',
          premiumAmount: 3400,
          premiumCadence: 'yearly',
          coverageLimit: 1000000,
          deductible: 1000,
          features: ['Zero Copay Preventative Care', 'Global Emergency Coverage', 'Mental Health In-Network'],
          valueScore: 90,
        },
        {
          provider: 'UnitedHealthcare',
          planName: 'Choice Plus Essential',
          premiumAmount: 2950,
          premiumCadence: 'yearly',
          coverageLimit: 750000,
          deductible: 1500,
          features: ['Virtual Visits $0', 'Prescription Tier 1 Included', 'Wellness Rewards'],
          valueScore: 86,
        },
      ],
      life: [
        {
          provider: 'Northwestern Mutual',
          planName: 'Term 20 Level Direct',
          premiumAmount: 600,
          premiumCadence: 'yearly',
          coverageLimit: 500000,
          deductible: 0,
          features: ['Fixed Premium 20 Yrs', 'Convertible to Whole Life', 'Terminal Illness Rider'],
          valueScore: 94,
        },
      ],
      home: [
        {
          provider: 'Allstate Home',
          planName: 'House & Property Protect',
          premiumAmount: 1250,
          premiumCadence: 'yearly',
          coverageLimit: 400000,
          deductible: 1000,
          features: ['Roof & Siding Protection', 'Personal Liability $300k', 'Water Backup Rider'],
          valueScore: 87,
        },
      ],
    };

    const selectedMarketPlans = marketDataset[type] || marketDataset['auto'];

    res.status(200).json({
      success: true,
      queryType: type,
      userPolicies,
      marketPlans: selectedMarketPlans,
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getComparisonDataset,
};
