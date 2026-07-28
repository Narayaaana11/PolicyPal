const dotenv = require('dotenv');
const path = require('path');

dotenv.config({ path: path.join(__dirname, '../../.env') });

const config = {
  port: process.env.PORT || 5000,
  mongodbUri: process.env.MONGODB_URI || 'mongodb://localhost:27017/policypal',
  jwtSecret: process.env.JWT_SECRET || 'default_jwt_secret_key_change_me',
  jwtRefreshSecret: process.env.JWT_REFRESH_SECRET || 'default_jwt_refresh_secret_key_change_me',
  jwtAccessExpiration: '15m',
  jwtRefreshExpiration: '7d',
  openrouterApiKey: process.env.OPENROUTER_API_KEY || '',
  openrouterModel: process.env.OPENROUTER_MODEL || 'google/gemini-2.5-flash',
};

module.exports = config;
