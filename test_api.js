const http = require('http');

const PORT = process.env.PORT || 5000;
const BASE_URL = `http://localhost:${PORT}`;

async function request(method, path, body = null, token = null) {
  const url = new URL(path, BASE_URL);
  const options = {
    method,
    headers: {
      'Content-Type': 'application/json',
    },
  };

  if (token) {
    options.headers['Authorization'] = `Bearer ${token}`;
  }

  return new Promise((resolve, reject) => {
    const req = http.request(url, options, (res) => {
      let data = '';
      res.on('data', (chunk) => (data += chunk));
      res.on('end', () => {
        try {
          const json = JSON.parse(data);
          resolve({ status: res.statusCode, body: json });
        } catch (e) {
          resolve({ status: res.statusCode, body: data });
        }
      });
    });

    req.on('error', reject);
    if (body) {
      req.write(JSON.stringify(body));
    }
    req.end();
  });
}

async function runTests() {
  console.log('=== Starting Full Backend API Suite Tests ===');

  // 1. Health check
  console.log('\n[1] GET /health');
  const health = await request('GET', '/health');
  console.log('Response:', health.status, health.body.status);

  // 2. Register
  console.log('\n[2] POST /api/auth/register');
  const testEmail = `testuser_${Date.now()}@example.com`;
  const regRes = await request('POST', '/api/auth/register', {
    name: 'Priya Sharma',
    email: testEmail,
    password: 'Password123!',
    phone: '+1-555-0192',
  });
  console.log('Response:', regRes.status, regRes.body.message);

  if (regRes.status !== 201) {
    console.error('Registration failed! Aborting.');
    return;
  }

  const { accessToken, refreshToken } = regRes.body.data;

  // 3. Login
  console.log('\n[3] POST /api/auth/login');
  const loginRes = await request('POST', '/api/auth/login', {
    email: testEmail,
    password: 'Password123!',
  });
  console.log('Response:', loginRes.status, loginRes.body.message);

  // 4. Create First Policy (Auto)
  console.log('\n[4] POST /api/policies (Auto Policy 1)');
  const policy1Res = await request(
    'POST',
    '/api/policies',
    {
      type: 'auto',
      provider: 'Geico Direct',
      policyNumber: 'AUTO-998877',
      premiumAmount: 1200,
      premiumCadence: 'yearly',
      startDate: '2026-01-01T00:00:00.000Z',
      endDate: '2026-08-15T00:00:00.000Z', // Expiring within 30 days
      coverageSummary: 'Comprehensive auto insurance policy.',
      exclusions: ['Racing', 'Unlicensed drivers'],
      nominee: 'Rahul Sharma',
    },
    accessToken
  );
  console.log('Response:', policy1Res.status, policy1Res.body.data?._id);

  const policy1Id = policy1Res.body.data?._id;

  // 5. Create Second Policy (Auto Overlap)
  console.log('\n[5] POST /api/policies (Auto Policy 2 - Overlap)');
  const policy2Res = await request(
    'POST',
    '/api/policies',
    {
      type: 'auto',
      provider: 'Progressive Shield',
      policyNumber: 'AUTO-112233',
      premiumAmount: 950,
      premiumCadence: 'yearly',
      startDate: '2026-02-01T00:00:00.000Z',
      endDate: '2027-02-01T00:00:00.000Z',
      coverageSummary: 'Secondary auto liability insurance.',
      exclusions: ['Off-road use'],
    },
    accessToken
  );
  console.log('Response:', policy2Res.status, policy2Res.body.data?._id);

  // 6. Overlap Detection Check
  console.log(`\n[6] GET /api/policies/${policy1Id}/overlap-check`);
  const overlapRes = await request(
    'GET',
    `/api/policies/${policy1Id}/overlap-check`,
    null,
    accessToken
  );
  console.log(
    'Response:',
    overlapRes.status,
    `Has Overlap: ${overlapRes.body.hasOverlap}`,
    `Count: ${overlapRes.body.overlapCount}`
  );

  // 7. Get Upcoming Payments
  console.log('\n[7] GET /api/payments/upcoming');
  const paymentsRes = await request('GET', '/api/payments/upcoming', null, accessToken);
  console.log('Response:', paymentsRes.status, `Upcoming Payments: ${paymentsRes.body.count}`);

  const paymentId = paymentsRes.body.data?.[0]?._id;

  // 8. Mark Payment Paid
  if (paymentId) {
    console.log(`\n[8] PATCH /api/payments/${paymentId}/mark-paid`);
    const markPaidRes = await request(
      'PATCH',
      `/api/payments/${paymentId}/mark-paid`,
      null,
      accessToken
    );
    console.log('Response:', markPaidRes.status, markPaidRes.body.message);
  }

  // 9. Submit Claim with AI Assessment
  console.log('\n[9] POST /api/claims (AI Claims Assistant)');
  const claimRes = await request(
    'POST',
    '/api/claims',
    {
      policyId: policy1Id,
      incidentDate: '2026-07-20T00:00:00.000Z',
      description: 'Minor bumper collision at parking spot.',
      photoUrls: ['https://storage.policypal.com/claims/bumper_damage_1.jpg'],
    },
    accessToken
  );
  console.log('Response:', claimRes.status, 'Disclaimer:', claimRes.body.data?.aiAssessment?.disclaimer ? 'PRESENT' : 'MISSING');

  // 10. Get Claims History
  console.log('\n[10] GET /api/claims');
  const claimsListRes = await request('GET', '/api/claims', null, accessToken);
  console.log('Response:', claimsListRes.status, `Claims Count: ${claimsListRes.body.count}`);

  // 11. Comparison Engine Endpoint
  console.log('\n[11] GET /api/compare?type=auto');
  const compareRes = await request('GET', '/api/compare?type=auto', null, accessToken);
  console.log('Response:', compareRes.status, `Market Plans Returned: ${compareRes.body.marketPlans?.length}`);

  // 12. Notifications & Renewal Warnings
  console.log('\n[12] GET /api/notifications');
  const notifRes = await request('GET', '/api/notifications', null, accessToken);
  console.log('Response:', notifRes.status, `Notifications Count: ${notifRes.body.count}`);

  // 13. Waitlist Signup (Public)
  console.log('\n[13] POST /api/waitlist');
  const waitlistRes = await request('POST', '/api/waitlist', {
    email: `waitlist_${Date.now()}@example.com`,
  });
  console.log('Response:', waitlistRes.status, waitlistRes.body.message);

  // 14. Contact Submission (Public)
  console.log('\n[14] POST /api/contact');
  const contactRes = await request('POST', '/api/contact', {
    name: 'Arjun Verma',
    email: 'arjun@example.com',
    subject: 'Partnership Inquiry',
    message: 'Interested in listing commercial fleet policies.',
  });
  console.log('Response:', contactRes.status, contactRes.body.message);

  // 15. Get Me Profile
  console.log('\n[15] GET /api/auth/me');
  const meRes = await request('GET', '/api/auth/me', null, accessToken);
  console.log('Response:', meRes.status, `User Name: ${meRes.body.data?.name}`);

  // 16. Update Profile
  console.log('\n[16] PUT /api/auth/profile');
  const updateRes = await request(
    'PUT',
    '/api/auth/profile',
    { name: 'Priya Sharma (Updated)', phone: '+91 98765 43210' },
    accessToken
  );
  console.log('Response:', updateRes.status, updateRes.body.message);

  // 17. AI Explain Clause Endpoint
  console.log('\n[17] POST /api/ai/explain-clause');
  const explainRes = await request(
    'POST',
    '/api/ai/explain-clause',
    { clauseText: 'Room Rent Capped at 1% of Sum Insured per day with Proportionate Deduction.' },
    accessToken
  );
  console.log('Response:', explainRes.status, 'Summary Length:', explainRes.body.data?.plainEnglish ? 'PRESENT' : 'MISSING');

  // 18. AI OCR Scan Endpoint
  console.log('\n[18] POST /api/ai/scan-ocr');
  const ocrRes = await request(
    'POST',
    '/api/ai/scan-ocr',
    { filename: 'digit_policy_schedule.pdf' },
    accessToken
  );
  console.log('Response:', ocrRes.status, 'Scanned Provider:', ocrRes.body.data?.provider);

  console.log('\n=== Full Backend API Suite Tests Completed Successfully ===');
}

runTests().catch(console.error);
