const mongoose = require('mongoose');

const claimSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      index: true,
    },
    policyId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Policy',
      required: true,
      index: true,
    },
    incidentDate: {
      type: Date,
      required: [true, 'Incident date is required'],
    },
    description: {
      type: String,
      required: [true, 'Incident description is required'],
      trim: true,
    },
    photoUrls: {
      type: [String],
      default: [],
    },
    aiAssessment: {
      relevantClauses: { type: [String], default: [] },
      possibleExclusions: { type: [String], default: [] },
      checklist: { type: [String], default: [] },
      confidenceNote: { type: String, default: '' },
      disclaimer: {
        type: String,
        default:
          'DISCLAIMER: PolicyPal provides information for guidance purposes only and does not constitute a formal coverage decision or guarantee. Final claim authorization rests solely with your insurance provider.',
      },
    },
    status: {
      type: String,
      enum: ['draft', 'submitted_to_insurer', 'resolved'],
      default: 'draft',
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model('Claim', claimSchema);
