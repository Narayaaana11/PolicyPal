const Claim = require('../models/Claim');
const Policy = require('../models/Policy');
const { assessClaim } = require('../services/ai.service');

const createClaim = async (req, res, next) => {
  try {
    const { policyId, incidentDate, description, photoUrls } = req.body;

    const policy = await Policy.findOne({
      _id: policyId,
      userId: req.user._id,
    });

    if (!policy) {
      return res.status(404).json({
        success: false,
        message: 'Associated policy not found',
      });
    }

    const aiAssessment = await assessClaim({
      policy,
      description,
      incidentDate,
      photoUrls: photoUrls || [],
    });

    const claim = await Claim.create({
      userId: req.user._id,
      policyId,
      incidentDate,
      description,
      photoUrls: photoUrls || [],
      aiAssessment,
      status: 'draft',
    });

    res.status(201).json({
      success: true,
      message: 'Claim incident created and AI pre-check completed',
      data: claim,
    });
  } catch (error) {
    next(error);
  }
};

const getClaims = async (req, res, next) => {
  try {
    const claims = await Claim.find({ userId: req.user._id })
      .populate('policyId', 'provider type policyNumber')
      .sort({ createdAt: -1 });

    res.status(200).json({
      success: true,
      count: claims.length,
      data: claims,
    });
  } catch (error) {
    next(error);
  }
};

const getClaimById = async (req, res, next) => {
  try {
    const claim = await Claim.findOne({
      _id: req.params.id,
      userId: req.user._id,
    }).populate('policyId', 'provider type policyNumber premiumAmount coverageSummary exclusions');

    if (!claim) {
      return res.status(404).json({
        success: false,
        message: 'Claim not found',
      });
    }

    res.status(200).json({
      success: true,
      data: claim,
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  createClaim,
  getClaims,
  getClaimById,
};
