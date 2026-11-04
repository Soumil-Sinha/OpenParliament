//
//  members.js
//  OpenParliament Server
//
//  Members of Parliament with their attendance history, committees and bill
//  engagements nested, so the app gets a complete profile in one request.
//  Enumerations travel as their database codes ('lok_sabha', 'sponsor'); the
//  app maps them onto its own types.
//

import { query } from '../db.js';

const MEMBER_SELECT = `
    SELECT json_build_object(
        'id', m.id,
        'name', m.name,
        'constituency', m.constituency,
        'state', m.state,
        'party', p.name,
        'partyAbbreviation', p.abbreviation,
        'house', m.house,
        'firstElected', m.first_elected,
        'questionsAsked', m.questions_asked,
        'committees', COALESCE((
            SELECT json_agg(c.name ORDER BY mc.position)
            FROM mp_committees mc
            JOIN committees c ON c.id = mc.committee_id
            WHERE mc.mp_id = m.id
        ), '[]'::json),
        'attendanceHistory', COALESCE((
            SELECT json_agg(json_build_object(
                'session', s.name,
                'shortLabel', s.short_label,
                'attendance', a.attendance_percent::float8
            ) ORDER BY s.ordinal)
            FROM attendance_records a
            JOIN parliament_sessions s ON s.id = a.session_id
            WHERE a.mp_id = m.id
        ), '[]'::json),
        'engagements', COALESCE((
            SELECT json_agg(json_build_object('billID', e.bill_id, 'role', e.role)
                            ORDER BY e.role, e.bill_id)
            FROM bill_engagements e
            WHERE e.mp_id = m.id
        ), '[]'::json)
    ) AS member
    FROM mps m
    JOIN parties p ON p.abbreviation = m.party_abbreviation
`;

export async function listMembers() {
    const rows = await query(`${MEMBER_SELECT} ORDER BY m.name`);
    return rows.map((row) => row.member);
}

export async function findMember(id) {
    const rows = await query(`${MEMBER_SELECT} WHERE m.id = $1`, [id]);
    return rows[0]?.member ?? null;
}
