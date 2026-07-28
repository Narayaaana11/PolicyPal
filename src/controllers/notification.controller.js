const Notification = require('../models/Notification');
const Policy = require('../models/Policy');

const getNotifications = async (req, res, next) => {
  try {
    const policies = await Policy.find({ userId: req.user._id });
    
    // Generate notification reminders for policy renewals within 30 days
    const now = new Date();
    const thirtyDaysFromNow = new Date();
    thirtyDaysFromNow.setDate(now.getDate() + 30);

    for (const policy of policies) {
      if (policy.endDate && policy.endDate <= thirtyDaysFromNow && policy.endDate >= now) {
        const existing = await Notification.findOne({
          userId: req.user._id,
          policyId: policy._id,
          type: 'renewal',
        });

        if (!existing) {
          await Notification.create({
            userId: req.user._id,
            policyId: policy._id,
            type: 'renewal',
            title: `Renewal Warning: ${policy.provider} ${policy.type.toUpperCase()}`,
            message: `Your policy #${policy.policyNumber} is expiring on ${new Date(policy.endDate).toLocaleDateString()}. Renew now to avoid lapse.`,
            scheduledFor: now,
            sent: true,
          });
        }
      }
    }

    const notifications = await Notification.find({ userId: req.user._id })
      .populate('policyId', 'provider type policyNumber endDate')
      .sort({ createdAt: -1 });

    res.status(200).json({
      success: true,
      count: notifications.length,
      data: notifications,
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getNotifications,
};
