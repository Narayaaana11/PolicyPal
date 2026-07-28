const { assessClaim, explainClause, scanDocumentOCR } = require('../services/ai.service');
const Policy = require('../models/Policy');

const handleAssessClaim = async (req, res, next) => {
  try {
    const { policyId, description, incidentDate, photoUrls } = req.body;

    let policy = null;
    if (policyId) {
      policy = await Policy.findOne({ _id: policyId, userId: req.user._id });
    }

    if (!policy) {
      policy = {
        type: req.body.type || 'health',
        provider: req.body.provider || 'Insurance Provider',
        exclusions: [],
      };
    }

    const assessment = await assessClaim({
      policy,
      description,
      incidentDate: incidentDate || new Date().toISOString(),
      photoUrls: photoUrls || [],
    });

    res.status(200).json({
      success: true,
      data: assessment,
    });
  } catch (error) {
    next(error);
  }
};

const handleExplainClause = async (req, res, next) => {
  try {
    const { clauseText } = req.body;

    if (!clauseText) {
      return res.status(400).json({
        success: false,
        message: 'Clause text is required',
      });
    }

    const explanation = await explainClause(clauseText);

    res.status(200).json({
      success: true,
      data: explanation,
    });
  } catch (error) {
    next(error);
  }
};

const handleScanOCR = async (req, res, next) => {
  try {
    // Accept both 'text' (Flutter app) and 'rawText' (legacy/test) field names
    const rawText = req.body.text || req.body.rawText || '';
    const filename = req.body.filename || 'policy_document.pdf';

    const scannedPolicy = await scanDocumentOCR({
      text: rawText,
      filename,
    });

    res.status(200).json({
      success: true,
      data: scannedPolicy,
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  handleAssessClaim,
  handleExplainClause,
  handleScanOCR,
};
