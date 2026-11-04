//
//  bills.js
//  OpenParliament Server
//
//  Bills with their key points, dated stage history and linked schemes.
//

import { query } from '../db.js';

const BILL_SELECT = `
    SELECT json_build_object(
        'id', b.id,
        'title', b.title,
        'billNumber', b.bill_number,
        'house', b.house,
        'ministry', mi.name,
        'stage', b.stage,
        'summary', b.summary,
        'keyPoints', COALESCE((
            SELECT json_agg(k.point ORDER BY k.position)
            FROM bill_key_points k
            WHERE k.bill_id = b.id
        ), '[]'::json),
        'stageHistory', COALESCE((
            SELECT json_agg(json_build_object(
                'stage', se.stage,
                'date', to_char(se.event_date, 'YYYY-MM-DD'),
                'detail', se.detail
            ) ORDER BY se.stage)
            FROM bill_stage_events se
            WHERE se.bill_id = b.id
        ), '[]'::json),
        'linkedSchemeIDs', COALESCE((
            SELECT json_agg(bs.scheme_id ORDER BY bs.scheme_id)
            FROM bill_schemes bs
            WHERE bs.bill_id = b.id
        ), '[]'::json)
    ) AS bill
    FROM bills b
    JOIN ministries mi ON mi.id = b.ministry_id
`;

export async function listBills() {
    const rows = await query(`${BILL_SELECT} ORDER BY b.id`);
    return rows.map((row) => row.bill);
}

export async function findBill(id) {
    const rows = await query(`${BILL_SELECT} WHERE b.id = $1`, [id]);
    return rows[0]?.bill ?? null;
}

export async function billExists(id) {
    const rows = await query('SELECT 1 FROM bills WHERE id = $1', [id]);
    return rows.length > 0;
}
