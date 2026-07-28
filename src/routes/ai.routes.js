const express = require('express');
const { body } = require('express-validator');
const { handleAssessClaim, handleExplainClause, handleScanOCR } = require('../controllers/ai.controller');
const { protect } = require('../middleware/auth.middleware');
const { validate } = require('../middleware/validate.middleware');

const router = express.Router();

router.use(protect);

router.post(
  '/assess-claim',
  [
    body('description').trim().notEmpty().withMessage('Description is required'),
    validate,
  ],
  handleAssessClaim
);

router.post(
  '/explain-clause',
  [
    body('clauseText').trim().notEmpty().withMessage('Clause text is required'),
    validate,
  ],
  handleExplainClause
);

router.post('/scan-ocr', handleScanOCR);

module.exports = router;
