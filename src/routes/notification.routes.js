const express = require('express');
const { getNotifications, markNotificationRead, clearAllNotifications } = require('../controllers/notification.controller');
const { protect } = require('../middleware/auth.middleware');

const router = express.Router();

router.use(protect);

router.get('/', getNotifications);
router.patch('/:id/read', markNotificationRead);
router.delete('/clear-all', clearAllNotifications);

module.exports = router;
