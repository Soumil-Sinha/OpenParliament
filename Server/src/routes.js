//
//  routes.js
//  OpenParliament Server
//
//  Every endpoint the app calls. Handlers receive the parsed request and
//  return a [status, body] pair; index.js does the writing.
//

import { HTTPError, Router } from './http.js';
import { pool } from './db.js';
import * as members from './repositories/members.js';
import * as bills from './repositories/bills.js';
import * as schemes from './repositories/schemes.js';
import * as speeches from './repositories/speeches.js';
import * as follows from './repositories/follows.js';

const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

/** The anonymous per-install identifier the app sends with follow requests. */
function deviceID(request) {
    const value = request.headers['x-device-id'];
    if (!value || !UUID.test(value)) {
        throw new HTTPError(400, 'X-Device-ID header must be a UUID');
    }
    return value.toLowerCase();
}

function found(record, kind) {
    if (!record) throw new HTTPError(404, `${kind} not found`);
    return [200, record];
}

export const router = new Router()

    .get('/api/health', async () => {
        const [{ now }] = (await pool.query('SELECT now()')).rows;
        return [200, { status: 'ok', database: 'connected', serverTime: now }];
    })

    // Everything the app needs at launch, in one round trip.
    .get('/api/snapshot', async () => {
        const [mps, billList, schemeList, speechList] = await Promise.all([
            members.listMembers(),
            bills.listBills(),
            schemes.listSchemes(),
            speeches.listSpeeches(),
        ]);
        return [200, { mps, bills: billList, schemes: schemeList, speeches: speechList }];
    })

    .get('/api/mps', async () => [200, await members.listMembers()])
    .get('/api/mps/:id', async ({ params }) => found(await members.findMember(params.id), 'Member'))

    .get('/api/bills', async () => [200, await bills.listBills()])
    .get('/api/bills/:id', async ({ params }) => found(await bills.findBill(params.id), 'Bill'))

    .get('/api/schemes', async () => [200, await schemes.listSchemes()])
    .get('/api/schemes/:id', async ({ params }) => found(await schemes.findScheme(params.id), 'Scheme'))

    .get('/api/speeches', async ({ searchParams }) => [200, await speeches.listSpeeches({
        mpID: searchParams.get('mp'),
        billID: searchParams.get('bill'),
    })])

    .get('/api/follows', async ({ request }) => [200, await follows.listFollows(deviceID(request))])

    .put('/api/follows/:billID', async ({ request, params }) => {
        const device = deviceID(request);
        if (!(await bills.billExists(params.billID))) throw new HTTPError(404, 'Bill not found');
        await follows.follow(device, params.billID);
        return [204];
    })

    .delete('/api/follows/:billID', async ({ request, params }) => {
        await follows.unfollow(deviceID(request), params.billID);
        return [204];
    })

    .get('/api/stats/followers', async () => [200, await follows.followerCounts()]);
