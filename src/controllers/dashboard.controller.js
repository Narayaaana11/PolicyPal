const Policy = require('../models/Policy');
const Payment = require('../models/Payment');
const Claim = require('../models/Claim');
const Notification = require('../models/Notification');

/**
 * GET /api/dashboard/stats
 * Returns aggregated portfolio statistics for the authenticated user.
 */
const getDashboardStats = async (req, res, next) => {
  try {
    const userId = req.user._id;

    const [policies, payments, claims, notifications] = await Promise.all([
      Policy.find({ userId }).lean(),
      Payment.find({ userId }).lean(),
      Claim.find({ userId }).lean(),
      Notification.find({ userId }).lean(),
    ]);

    // Coverage breakdown by type
    const coverageByType = {};
    policies.forEach((p) => {
      if (!coverageByType[p.type]) {
        coverageByType[p.type] = { count: 0, totalPremium: 0 };
      }
      coverageByType[p.type].count += 1;
      coverageByType[p.type].totalPremium += p.premiumAmount || 0;
    });

    // Active vs expired vs cancelled
    const activePolicies = policies.filter((p) => p.status === 'active');
    const expiredPolicies = policies.filter((p) => p.status === 'expired');
    const cancelledPolicies = policies.filter((p) => p.status === 'cancelled');

    // Total annual premium (active policies only)
    const totalAnnualPremium = activePolicies.reduce((sum, p) => {
      const multiplier =
        p.premiumCadence === 'monthly' ? 12 : p.premiumCadence === 'quarterly' ? 4 : 1;
      return sum + (p.premiumAmount || 0) * multiplier;
    }, 0);

    // Upcoming renewals within 30 days
    const now = new Date();
    const thirtyDaysFromNow = new Date();
    thirtyDaysFromNow.setDate(now.getDate() + 30);

    const upcomingRenewals = activePolicies
      .filter((p) => p.endDate && new Date(p.endDate) <= thirtyDaysFromNow && new Date(p.endDate) >= now)
      .map((p) => ({
        id: p._id,
        provider: p.provider,
        type: p.type,
        policyNumber: p.policyNumber,
        endDate: p.endDate,
        daysUntilExpiry: Math.ceil((new Date(p.endDate) - now) / (1000 * 60 * 60 * 24)),
      }));

    // Payment summary
    const paidPayments = payments.filter((p) => p.status === 'paid');
    const overduePayments = payments.filter((p) => p.status === 'overdue');
    const upcomingPayments = payments.filter((p) => p.status === 'upcoming');

    // Claims summary
    const draftClaims = claims.filter((c) => c.status === 'draft');
    const submittedClaims = claims.filter((c) => c.status === 'submitted_to_insurer');
    const resolvedClaims = claims.filter((c) => c.status === 'resolved');

    // Health policy Section 80D tax deduction
    const healthPremiumTotal = activePolicies
      .filter((p) => p.type === 'health')
      .reduce((sum, p) => sum + (p.premiumAmount || 0), 0);

    res.status(200).json({
      success: true,
      data: {
        overview: {
          totalPolicies: policies.length,
          activePolicies: activePolicies.length,
          expiredPolicies: expiredPolicies.length,
          cancelledPolicies: cancelledPolicies.length,
          totalAnnualPremium,
        },
        coverageByType,
        upcomingRenewals,
        payments: {
          total: payments.length,
          paid: paidPayments.length,
          overdue: overduePayments.length,
          upcoming: upcomingPayments.length,
          totalPaid: paidPayments.reduce((s, p) => s + (p.amount || 0), 0),
        },
        claims: {
          total: claims.length,
          draft: draftClaims.length,
          submitted: submittedClaims.length,
          resolved: resolvedClaims.length,
        },
        notifications: {
          total: notifications.length,
          unread: notifications.filter((n) => !n.read).length,
        },
        taxSavings: {
          section80D: {
            healthPremiumTotal,
            maxDeduction: 25000,
            eligible: Math.min(healthPremiumTotal, 25000),
          },
        },
      },
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getDashboardStats,
};
