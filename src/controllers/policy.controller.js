const Policy = require('../models/Policy');
const { processPolicyPDF } = require('../services/pdf.service');

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
    const { type, status, provider } = req.query;
    const filter = { userId: req.user._id };

    if (type) {
      filter.type = type;
    }
    if (status) {
      filter.status = status;
    }
    if (provider) {
      filter.provider = { $regex: provider, $options: 'i' };
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

const createPolicyFromPDF = async (req, res, next) => {
  try {
    if (!req.file) {
      return res.status(400).json({
        success: false,
        message: 'No PDF file uploaded. Please attach a policy PDF document.',
      });
    }

    // Step 1: Extract text from PDF and get AI-parsed policy data
    const { extractedText, pageCount, pdfInfo, aiParsedPolicy } = await processPolicyPDF(
      req.file.buffer,
      req.file.originalname
    );

    // Step 2: Create the policy using AI-extracted fields
    // User can override any field via request body
    const policyData = {
      userId: req.user._id,
      type: req.body.type || aiParsedPolicy.type || 'other',
      provider: req.body.provider || aiParsedPolicy.provider || 'Unknown Provider',
      policyNumber: req.body.policyNumber || aiParsedPolicy.policyNumber || `PDF-${Date.now().toString().slice(-8)}`,
      premiumAmount: req.body.premiumAmount || aiParsedPolicy.premiumAmount || 0,
      premiumCadence: req.body.premiumCadence || aiParsedPolicy.premiumCadence || 'yearly',
      startDate: req.body.startDate || aiParsedPolicy.startDate || new Date().toISOString(),
      endDate: req.body.endDate || aiParsedPolicy.endDate || new Date(Date.now() + 365 * 24 * 60 * 60 * 1000).toISOString(),
      coverageSummary: req.body.coverageSummary || aiParsedPolicy.coverageSummary || '',
      exclusions: req.body.exclusions || aiParsedPolicy.exclusions || [],
      nominee: req.body.nominee || aiParsedPolicy.nominee || '',
      extractedText: extractedText.substring(0, 50000), // Store first 50k chars of extracted text
      documentUrl: `uploaded://${req.file.originalname}`,
      status: 'active',
    };

    const policy = await Policy.create(policyData);

    res.status(201).json({
      success: true,
      message: 'Policy created from PDF successfully! AI has analyzed your document.',
      data: {
        policy,
        aiAnalysis: {
          parsedFields: aiParsedPolicy,
          pdfInfo: {
            filename: req.file.originalname,
            pageCount,
            fileSize: `${(req.file.size / 1024).toFixed(1)} KB`,
            ...pdfInfo,
          },
          accuracyScore: aiParsedPolicy.accuracyScore || 85,
        },
      },
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
  createPolicyFromPDF,
};
