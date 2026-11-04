//
//  follows.js
//  OpenParliament Server
//
//  The one piece of writable state: which bills a device follows. Follow and
//  unfollow are idempotent, so the app can retry them freely.
//

import { query } from '../db.js';

export async function listFollows(deviceID) {
    return query(`
        SELECT bill_id AS "billID", followed_at AS "followedAt"
        FROM bill_follows
        WHERE device_id = $1
        ORDER BY followed_at DESC
    `, [deviceID]);
}

export async function follow(deviceID, billID) {
    await query(`
        INSERT INTO bill_follows (device_id, bill_id)
        VALUES ($1, $2)
        ON CONFLICT (device_id, bill_id) DO NOTHING
    `, [deviceID, billID]);
}

export async function unfollow(deviceID, billID) {
    await query('DELETE FROM bill_follows WHERE device_id = $1 AND bill_id = $2', [deviceID, billID]);
}

export async function followerCounts() {
    const rows = await query('SELECT bill_id AS "billID", followers::int FROM bill_follower_counts');
    return Object.fromEntries(rows.map((row) => [row.billID, row.followers]));
}
