//
//  speeches.js
//  OpenParliament Server
//
//  Floor interventions, most recent first. Optional filters narrow the list
//  to one member or one bill.
//

import { query } from '../db.js';

export async function listSpeeches({ mpID, billID } = {}) {
    const conditions = [];
    const params = [];
    if (mpID) {
        params.push(mpID);
        conditions.push(`mp_id = $${params.length}`);
    }
    if (billID) {
        params.push(billID);
        conditions.push(`bill_id = $${params.length}`);
    }
    const where = conditions.length ? `WHERE ${conditions.join(' AND ')}` : '';

    return query(`
        SELECT
            id,
            mp_id AS "mpID",
            bill_id AS "billID",
            topic,
            to_char(spoken_on, 'YYYY-MM-DD') AS date,
            duration_minutes AS "durationMinutes",
            excerpt
        FROM speeches
        ${where}
        ORDER BY spoken_on DESC, id
    `, params);
}
