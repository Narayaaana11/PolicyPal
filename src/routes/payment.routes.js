const express = require('express');
const { getUpcomingPayments, markPaymentPaid } = require('../controllers/payment.controller');
const { protect } = require('../middleware/auth.middleware');

const router = express.Router();

router.use(protect);

router.get('/upcoming', getUpcomingPayments);
router.patch('/:id/mark-paid', markPaymentPaid);

module.exports = router;
