//
//  schemes.js
//  OpenParliament Server
//
//  Budget schemes with four years of allocation and expenditure, plus the
//  optional CAG audit observation.
//

import { query } from '../db.js';

const SCHEME_SELECT = `
    SELECT json_build_object(
        'id', s.id,
        'name', s.name,
        'sector', s.sector,
        'ministry', mi.name,
        'summary', s.summary,
        'years', COALESCE((
            SELECT json_agg(json_build_object(
                'label', f.label,
                'fullLabel', f.full_label,
                'allocation', f.allocation_crore::float8,
                'actual', f.actual_crore::float8
            ) ORDER BY f.label)
            FROM fiscal_year_spend f
            WHERE f.scheme_id = s.id
        ), '[]'::json),
        'cagFinding', (
            SELECT json_build_object('reference', c.reference, 'note', c.note)
            FROM cag_findings c
            WHERE c.scheme_id = s.id
        )
    ) AS scheme
    FROM schemes s
    JOIN ministries mi ON mi.id = s.ministry_id
`;

export async function listSchemes() {
    const rows = await query(`${SCHEME_SELECT} ORDER BY s.id`);
    return rows.map((row) => row.scheme);
}

export async function findScheme(id) {
    const rows = await query(`${SCHEME_SELECT} WHERE s.id = $1`, [id]);
    return rows[0]?.scheme ?? null;
}
