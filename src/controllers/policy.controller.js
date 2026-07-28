const Policy = require('../models/Policy');

const createPolicy = async (req, res, next) => {
  try {
    const {
      type,
      provider,
      policyNumber,
      premiumAmount,
      premiumCadence,
      startDate,
      endDate,
      coverageSummary,
      exclusions,
      nominee,
      status,
    } = req.body;

    const policy = await Policy.create({
      userId: req.user._id,
      type,
      provider,
      policyNumber,
      premiumAmount,
      premiumCadence,
      startDate,
      endDate,
      coverageSummary: coverageSummary || '',
      exclusions: exclusions || [],
      nominee: nominee || '',
      status: status || 'active',
    });

    res.status(201).json({
      success: true,
      message: 'Policy created successfully',
      data: policy,
    });
  } catch (error) {
    next(error);
  }
};

const getPolicies = async (req, res, next) => {
  try {
    const { type, status } = req.query;
    const filter = { userId: req.user._id };

    if (type) {
      filter.type = type;
    }
    if (status) {
      filter.status = status;
    }

    const policies = await Policy.find(filter).sort({ createdAt: -1 });

    res.status(200).json({
      success: true,
      count: policies.length,
      data: policies,
    });
  } catch (error) {
    next(error);
  }
};

const getPolicyById = async (req, res, next) => {
  try {
    const policy = await Policy.findOne({
      _id: req.params.id,
      userId: req.user._id,
    });

    if (!policy) {
      return res.status(404).json({
        success: false,
        message: 'Policy not found',
      });
    }

    res.status(200).json({
      success: true,
      data: policy,
    });
  } catch (error) {
    next(error);
  }
};

const updatePolicy = async (req, res, next) => {
  try {
    let policy = await Policy.findOne({
      _id: req.params.id,
      userId: req.user._id,
    });

    if (!policy) {
      return res.status(404).json({
        success: false,
        message: 'Policy not found',
      });
    }

    const allowedFields = [
      'type',
      'provider',
      'policyNumber',
      'premiumAmount',
      'premiumCadence',
      'startDate',
      'endDate',
      'coverageSummary',
      'exclusions',
      'nominee',
      'status',
    ];

    allowedFields.forEach((field) => {
      if (req.body[field] !== undefined) {
        policy[field] = req.body[field];
      }
    });

    await policy.save();

    res.status(200).json({
      success: true,
      message: 'Policy updated successfully',
      data: policy,
    });
  } catch (error) {
    next(error);
  }
};

const deletePolicy = async (req, res, next) => {
  try {
    const policy = await Policy.findOneAndDelete({
      _id: req.params.id,
      userId: req.user._id,
    });

    if (!policy) {
      return res.status(404).json({
        success: false,
        message: 'Policy not found',
      });
    }

    res.status(200).json({
      success: true,
      message: 'Policy deleted successfully',
    });
  } catch (error) {
    next(error);
  }
};

const checkPolicyOverlap = async (req, res, next) => {
  try {
    const policy = await Policy.findOne({
      _id: req.params.id,
      userId: req.user._id,
    });

    if (!policy) {
      return res.status(404).json({
        success: false,
        message: 'Policy not found',
      });
    }

    const otherPolicies = await Policy.find({
      userId: req.user._id,
      _id: { $ne: policy._id },
      type: policy.type,
      status: 'active',
    });

    const overlaps = otherPolicies.map((other) => ({
      overlappingPolicyId: other._id,
      overlappingProvider: other.provider,
      overlappingPolicyNumber: other.policyNumber,
      riskCategory: `${policy.type.toUpperCase()} Coverage Overlap`,
      details: `Both ${policy.provider} (${policy.policyNumber}) and ${other.provider} (${other.policyNumber}) cover ${policy.type} risks. You may be paying duplicate premiums.`,
      recommendation: 'Review limits and consider consolidating or canceling redundant coverage to save costs.',
    }));

    res.status(200).json({
      success: true,
      hasOverlap: overlaps.length > 0,
      overlapCount: overlaps.length,
      targetPolicy: {
        id: policy._id,
        provider: policy.provider,
        type: policy.type,
      },
      overlaps,
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  createPolicy,
  getPolicies,
  getPolicyById,
  updatePolicy,
  deletePolicy,
  checkPolicyOverlap,
};
