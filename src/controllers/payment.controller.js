const Payment = require('../models/Payment');
const Policy = require('../models/Policy');

const getUpcomingPayments = async (req, res, next) => {
  try {
    const policies = await Policy.find({ userId: req.user._id, status: 'active' });
    const policyIds = policies.map((p) => p._id);

    let payments = await Payment.find({
      userId: req.user._id,
      status: { $in: ['upcoming', 'overdue'] },
    }).populate('policyId', 'provider type policyNumber premiumAmount premiumCadence');

    // Auto-generate upcoming payment schedule if none exist for active policies
    if (payments.length === 0 && policies.length > 0) {
      const newPayments = [];
      for (const policy of policies) {
        const dueDate = new Date();
        dueDate.setDate(dueDate.getDate() + 14); // Due in 14 days

        const created = await Payment.create({
          userId: req.user._id,
          policyId: policy._id,
          amount: policy.premiumAmount,
          dueDate,
          status: 'upcoming',
        });
        newPayments.push(created);
      }
      payments = await Payment.find({ userId: req.user._id }).populate(
        'policyId',
        'provider type policyNumber premiumAmount premiumCadence'
      );
    }

    res.status(200).json({
      success: true,
      count: payments.length,
      data: payments,
    });
  } catch (error) {
    next(error);
  }
};

const markPaymentPaid = async (req, res, next) => {
  try {
    const payment = await Payment.findOne({
      _id: req.params.id,
      userId: req.user._id,
    });

    if (!payment) {
      return res.status(404).json({
        success: false,
        message: 'Payment record not found',
      });
    }

    payment.status = 'paid';
    payment.paidDate = new Date();
    await payment.save();

    res.status(200).json({
      success: true,
      message: 'Payment marked as paid',
      data: payment,
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getUpcomingPayments,
  markPaymentPaid,
};
