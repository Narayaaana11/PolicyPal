const express = require('express');
const { body } = require('express-validator');
const { handleAgentChat } = require('../controllers/agent.controller');
const { protect } = require('../middleware/auth.middleware');
const { validate } = require('../middleware/validate.middleware');

const router = express.Router();

router.use(protect);

router.post(
  '/chat',
  [
    body('message').trim().notEmpty().withMessage('Message is required'),
    validate,
  ],
  handleAgentChat
);

module.exports = router;
