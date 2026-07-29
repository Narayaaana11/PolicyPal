const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const compression = require('compression');
const rateLimit = require('express-rate-limit');
const config = require('./src/config/env');
const connectDB = require('./src/config/db');
const authRoutes = require('./src/routes/auth.routes');
const policyRoutes = require('./src/routes/policy.routes');
const paymentRoutes = require('./src/routes/payment.routes');
const claimRoutes = require('./src/routes/claim.routes');
const comparisonRoutes = require('./src/routes/comparison.routes');
const notificationRoutes = require('./src/routes/notification.routes');
const landingRoutes = require('./src/routes/landing.routes');
const aiRoutes = require('./src/routes/ai.routes');
const agentRoutes = require('./src/routes/agent.routes');
const catalogRoutes = require('./src/routes/catalog.routes');
const dashboardRoutes = require('./src/routes/dashboard.routes');
const errorHandler = require('./src/middleware/error.middleware');

const app = express();

connectDB();

app.use(helmet());
app.use(cors());
app.use(compression());
app.use(morgan('dev'));
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ extended: true, limit: '50mb' }));

const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100,
  standardHeaders: true,
  legacyHeaders: false,
  message: {
    success: false,
    message: 'Too many login/registration attempts, please try again later.',
  },
});

app.use('/api/auth', authLimiter, authRoutes);
app.use('/api/policies', catalogRoutes); // Put catalog routes before policyRoutes so /api/policies/catalog is matched before /api/policies/:id
app.use('/api/policies', policyRoutes);
app.use('/api/payments', paymentRoutes);
app.use('/api/claims', claimRoutes);
app.use('/api/compare', comparisonRoutes);
app.use('/api/notifications', notificationRoutes);
app.use('/api/ai', aiRoutes);
app.use('/api/agent', agentRoutes);
app.use('/api/dashboard', dashboardRoutes);
app.use('/api', landingRoutes); // /api/waitlist & /api/contact

app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'UP',
    timestamp: new Date().toISOString(),
  });
});

app.use(errorHandler);

const PORT = config.port;
const server = app.listen(PORT, () => {
  console.log(`[PolicyPal API] Server running on port ${PORT}`);
});

process.on('unhandledRejection', (err) => {
  console.error(`[Unhandled Rejection] ${err.message}`);
  server.close(() => process.exit(1));
});

module.exports = app;
