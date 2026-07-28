const express = require('express');
const { body } = require('express-validator');
const {
  createPolicy,
  getPolicies,
  getPolicyById,
  updatePolicy,
  deletePolicy,
  checkPolicyOverlap,
} = require('../controllers/policy.controller');
const { protect } = require('../middleware/auth.middleware');
const { validate } = require('../middleware/validate.middleware');

const router = express.Router();

router.use(protect);

router
  .route('/')
  .post(
    [
      body('type')
        .isIn(['health', 'auto', 'life', 'home', 'travel', 'other'])
        .withMessage('Valid policy type is required'),
      body('provider').trim().notEmpty().withMessage('Provider is required'),
      body('policyNumber').trim().notEmpty().withMessage('Policy number is required'),
      body('premiumAmount')
        .isNumeric()
        .withMessage('Premium amount must be a number'),
      body('premiumCadence')
        .isIn(['monthly', 'quarterly', 'yearly'])
        .withMessage('Valid premium cadence is required'),
      body('startDate').isISO8601().withMessage('Valid start date is required'),
      body('endDate').isISO8601().withMessage('Valid end date is required'),
      validate,
    ],
    createPolicy
  )
  .get(getPolicies);

router
  .route('/:id')
  .get(getPolicyById)
  .put(updatePolicy)
  .delete(deletePolicy);

router.get('/:id/overlap-check', checkPolicyOverlap);

module.exports = router;
