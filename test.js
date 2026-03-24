const http = require('http');

const options = {
  hostname: 'localhost',
  port: 3000,
  path: '/health',
  method: 'GET'
};

const req = http.request(options, (res) => {
  if (res.statusCode === 200) {
    console.log('TEST PASSED: Health check OK');
    process.exit(0);
  } else {
    console.log('TEST FAILED: Status', res.statusCode);
    process.exit(1);
  }
});

req.on('error', (e) => {
  console.log('TEST FAILED:', e.message);
  process.exit(1);
});

req.end();
