const express = require('express');
const { body } = require('express-validator');
const { createClaim, getClaims, getClaimById } = require('../controllers/claim.controller');
const { protect } = require('../middleware/auth.middleware');
const { validate } = require('../middleware/validate.middleware');

const router = express.Router();

router.use(protect);

router
  .route('/')
  .post(
    [
      body('policyId').notEmpty().withMessage('Policy ID is required'),
      body('incidentDate').isISO8601().withMessage('Valid incident date is required'),
      body('description').trim().notEmpty().withMessage('Description is required'),
      validate,
    ],
    createClaim
  )
  .get(getClaims);

router.route('/:id').get(getClaimById);

module.exports = router;
