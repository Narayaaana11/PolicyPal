const { processAgentChat } = require('../services/agent.service');

const handleAgentChat = async (req, res, next) => {
  try {
    const { message, conversationHistory } = req.body;

    if (!message || typeof message !== 'string') {
      return res.status(400).json({
        success: false,
        message: 'Message text is required',
      });
    }

    const response = await processAgentChat({
      userId: req.user._id,
      userMessage: message,
      conversationHistory: conversationHistory || [],
    });

    res.status(200).json({
      success: true,
      data: response,
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  handleAgentChat,
};
