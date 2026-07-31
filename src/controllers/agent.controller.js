const { processAgentChat, getProactiveInsights } = require('../services/agent.service');

const handleAgentChat = async (req, res, next) => {
  try {
    const { message, image, conversationHistory } = req.body;

    if ((!message || typeof message !== 'string') && !image) {
      return res.status(400).json({
        success: false,
        message: 'Message text or image is required',
      });
    }

    const response = await processAgentChat({
      userId: req.user._id,
      userMessage: message || '',
      imageBase64: image || null,
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

const handleGetInsights = async (req, res, next) => {
  try {
    const insights = await getProactiveInsights(req.user._id);

    res.status(200).json({
      success: true,
      data: insights,
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  handleAgentChat,
  handleGetInsights,
};
