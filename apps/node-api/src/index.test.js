const { test } = require('node:test');
const assert = require('node:assert/strict');

test('health response shape', () => {
  const payload = { status: 'ok', service: 'node-api' };
  assert.equal(payload.status, 'ok');
  assert.equal(payload.service, 'node-api');
});

test('root response has message', () => {
  const payload = { message: 'Hello from unified-reference-stack / node-api' };
  assert.ok(payload.message.length > 0);
});
