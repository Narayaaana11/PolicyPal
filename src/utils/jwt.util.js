const jwt = require('jsonwebtoken');
const config = require('../config/env');

const generateAccessToken = (userId) => {
  return jwt.sign({ id: userId }, config.jwtSecret, {
    expiresIn: config.jwtAccessExpiration,
  });
};

const generateRefreshToken = (userId) => {
  return jwt.sign(
    { id: userId, jti: `${Date.now()}_${Math.random().toString(36).substring(2)}` },
    config.jwtRefreshSecret,
    {
      expiresIn: config.jwtRefreshExpiration,
    }
  );
};

const verifyAccessToken = (token) => {
  return jwt.verify(token, config.jwtSecret);
};

const verifyRefreshToken = (token) => {
  return jwt.verify(token, config.jwtRefreshSecret);
};

module.exports = {
  generateAccessToken,
  generateRefreshToken,
  verifyAccessToken,
  verifyRefreshToken,
};
