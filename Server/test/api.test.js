//
//  api.test.js
//  OpenParliament Server
//
//  End-to-end checks against a running server and a seeded database:
//      npm run db:setup && npm start   (in one terminal)
//      npm test                        (in another)
//

import assert from 'node:assert/strict';
import { randomUUID } from 'node:crypto';
import { test } from 'node:test';

const BASE = process.env.API_URL ?? 'http://localhost:8080';
const device = randomUUID();

async function call(method, path, headers = {}) {
    const response = await fetch(`${BASE}${path}`, { method, headers });
    const text = await response.text();
    return { status: response.status, body: text ? JSON.parse(text) : undefined };
}

test('health reports a connected database', async () => {
    const { status, body } = await call('GET', '/api/health');
    assert.equal(status, 200);
    assert.equal(body.database, 'connected');
});

test('snapshot returns every collection with nested records', async () => {
    const { status, body } = await call('GET', '/api/snapshot');
    assert.equal(status, 200);
    assert.ok(body.mps.length > 0 && body.bills.length > 0 && body.schemes.length > 0);
    assert.equal(body.mps[0].attendanceHistory.length, 7);
    assert.ok(body.bills.every((bill) => bill.stageHistory.length > 0));
    assert.ok(body.schemes.every((scheme) => scheme.years.length === 4));
});

test('unknown records return 404', async () => {
    assert.equal((await call('GET', '/api/bills/does-not-exist')).status, 404);
    assert.equal((await call('GET', '/api/nowhere')).status, 404);
});

test('speeches filter by member', async () => {
    const { body } = await call('GET', '/api/speeches?mp=mp-raghavan');
    assert.ok(body.length > 0);
    assert.ok(body.every((speech) => speech.mpID === 'mp-raghavan'));
});

test('follow and unfollow round-trip through the database', async () => {
    const headers = { 'X-Device-ID': device };
    assert.equal((await call('PUT', '/api/follows/bill-dpdp', headers)).status, 204);
    assert.equal((await call('PUT', '/api/follows/bill-dpdp', headers)).status, 204); // idempotent
    let { body } = await call('GET', '/api/follows', headers);
    assert.deepEqual(body.map((row) => row.billID), ['bill-dpdp']);

    assert.equal((await call('DELETE', '/api/follows/bill-dpdp', headers)).status, 204);
    ({ body } = await call('GET', '/api/follows', headers));
    assert.equal(body.length, 0);
});

test('follow requests need a device id', async () => {
    assert.equal((await call('GET', '/api/follows')).status, 400);
    assert.equal((await call('PUT', '/api/follows/bill-dpdp', { 'X-Device-ID': 'nope' })).status, 400);
});
