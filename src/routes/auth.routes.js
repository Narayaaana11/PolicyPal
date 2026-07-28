const express = require('express');
const { body } = require('express-validator');
const { register, login, refresh, logout } = require('../controllers/auth.controller');
const { validate } = require('../middleware/validate.middleware');

const router = express.Router();

router.post(
  '/register',
  [
    body('name').trim().notEmpty().withMessage('Name is required'),
    body('email').isEmail().withMessage('Please provide a valid email'),
    body('password')
      .isLength({ min: 6 })
      .withMessage('Password must be at least 6 characters long'),
    validate,
  ],
  register
);

router.post(
  '/login',
  [
    body('email').isEmail().withMessage('Please provide a valid email'),
    body('password').notEmpty().withMessage('Password is required'),
    validate,
  ],
  login
);

router.post(
  '/refresh',
  [
    body('refreshToken').notEmpty().withMessage('Refresh token is required'),
    validate,
  ],
  refresh
);

router.post('/logout', logout);

module.exports = router;
