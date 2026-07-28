const express = require('express');
const { body } = require('express-validator');
const { handleAssessClaim, handleExplainClause, handleScanOCR, handleChat } = require('../controllers/ai.controller');
const { protect } = require('../middleware/auth.middleware');
const { validate } = require('../middleware/validate.middleware');

const router = express.Router();

// All AI routes require auth
router.use(protect);

// POST /api/ai/chat — Main insurance AI assistant
router.post(
  '/chat',
  [body('message').trim().notEmpty().withMessage('Message is required'), validate],
  handleChat
);

// POST /api/ai/assess-claim — Claim pre-check
router.post(
  '/assess-claim',
  [body('description').trim().notEmpty().withMessage('Description is required'), validate],
  handleAssessClaim
);

// POST /api/ai/explain-clause — Clause translation
router.post(
  '/explain-clause',
  [body('clauseText').trim().notEmpty().withMessage('Clause text is required'), validate],
  handleExplainClause
);

// POST /api/ai/scan-ocr — Document OCR parsing
router.post('/scan-ocr', handleScanOCR);

module.exports = router;
