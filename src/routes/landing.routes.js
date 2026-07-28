const express = require('express');
const { body } = require('express-validator');
const { joinWaitlist, submitContact } = require('../controllers/landing.controller');
const { validate } = require('../middleware/validate.middleware');

const router = express.Router();

router.post(
  '/waitlist',
  [body('email').isEmail().withMessage('Please provide a valid email'), validate],
  joinWaitlist
);

router.post(
  '/contact',
  [
    body('name').trim().notEmpty().withMessage('Name is required'),
    body('email').isEmail().withMessage('Please provide a valid email'),
    body('message').trim().notEmpty().withMessage('Message is required'),
    validate,
  ],
  submitContact
);

module.exports = router;
