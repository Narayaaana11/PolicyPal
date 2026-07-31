const express = require('express');
const { handleAgentChat, handleGetInsights } = require('../controllers/agent.controller');
const { protect } = require('../middleware/auth.middleware');

const router = express.Router();

router.use(protect);

router.post('/chat', handleAgentChat);
router.get('/insights', handleGetInsights);

module.exports = router;
