//
//  db.js
//  OpenParliament Server
//
//  Single connection pool shared by every repository.
//

import pg from 'pg';
import { config } from './config.js';

export const pool = new pg.Pool({
    database: config.database,
    max: 10,
    idleTimeoutMillis: 30_000,
});

/** Runs a parameterised query and returns its rows. */
export async function query(text, params = []) {
    const result = await pool.query(text, params);
    return result.rows;
}
