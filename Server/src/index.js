//
//  index.js
//  OpenParliament Server
//
//  Entry point: starts the HTTP server, dispatches to the router and turns
//  thrown errors into JSON responses.
//

import http from 'node:http';
import { config } from './config.js';
import { pool } from './db.js';
import { HTTPError, sendEmpty, sendJSON } from './http.js';
import { router } from './routes.js';

const server = http.createServer(async (request, response) => {
    const started = Date.now();
    const url = new URL(request.url, `http://${request.headers.host ?? 'localhost'}`);

    try {
        const { handler, params } = router.match(request.method, url.pathname);
        const [status, body] = await handler({ request, params, searchParams: url.searchParams });
        if (body === undefined) {
            sendEmpty(response, status);
        } else {
            sendJSON(response, status, body);
        }
    } catch (error) {
        const status = error instanceof HTTPError ? error.status : 500;
        if (status === 500) console.error(error);
        sendJSON(response, status, { error: status === 500 ? 'Internal server error' : error.message });
    } finally {
        console.log(`${request.method} ${url.pathname} → ${response.statusCode} (${Date.now() - started} ms)`);
    }
});

server.listen(config.port, config.host, () => {
    console.log(`OpenParliament API listening on http://localhost:${config.port} (database: ${config.database})`);
});

function shutdown() {
    server.close(() => pool.end().then(() => process.exit(0)));
}

process.on('SIGINT', shutdown);
process.on('SIGTERM', shutdown);
