const mongoose = require('mongoose');

const policySchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: [true, 'User ID is required'],
      index: true,
    },
    type: {
      type: String,
      required: [true, 'Policy type is required'],
      enum: {
        values: ['health', 'auto', 'life', 'home', 'travel', 'other'],
        message: '{VALUE} is not a valid policy type',
      },
    },
    provider: {
      type: String,
      required: [true, 'Provider name is required'],
      trim: true,
    },
    policyNumber: {
      type: String,
      required: [true, 'Policy number is required'],
      trim: true,
    },
    premiumAmount: {
      type: Number,
      required: [true, 'Premium amount is required'],
      min: [0, 'Premium amount cannot be negative'],
    },
    premiumCadence: {
      type: String,
      required: [true, 'Premium cadence is required'],
      enum: {
        values: ['monthly', 'quarterly', 'yearly'],
        message: '{VALUE} is not a valid premium cadence',
      },
    },
    startDate: {
      type: Date,
      required: [true, 'Start date is required'],
    },
    endDate: {
      type: Date,
      required: [true, 'End date is required'],
    },
    coverageSummary: {
      type: String,
      default: '',
    },
    exclusions: {
      type: [String],
      default: [],
    },
    documentUrl: {
      type: String,
      default: null,
    },
    extractedText: {
      type: String,
      default: '',
    },
    nominee: {
      type: String,
      trim: true,
      default: '',
    },
    status: {
      type: String,
      enum: {
        values: ['active', 'expired', 'cancelled'],
        message: '{VALUE} is not a valid status',
      },
      default: 'active',
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model('Policy', policySchema);
