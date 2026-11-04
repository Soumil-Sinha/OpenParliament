//
//  http.js
//  OpenParliament Server
//
//  A deliberately tiny router on top of node:http — the API has a handful of
//  routes, so a framework would add more surface than it removes.
//

/** An error that maps directly onto an HTTP status. */
export class HTTPError extends Error {
    constructor(status, message) {
        super(message);
        this.status = status;
    }
}

export class Router {
    #routes = [];

    /** Registers a handler. Path segments starting with ':' are captured as params. */
    on(method, path, handler) {
        const keys = [];
        const pattern = path.replace(/:(\w+)/g, (_, key) => {
            keys.push(key);
            return '([^/]+)';
        });
        this.#routes.push({ method, regex: new RegExp(`^${pattern}/?$`), keys, handler });
        return this;
    }

    get(path, handler) { return this.on('GET', path, handler); }
    put(path, handler) { return this.on('PUT', path, handler); }
    delete(path, handler) { return this.on('DELETE', path, handler); }

    /** Finds the handler for a request, or reports 404 / 405. */
    match(method, pathname) {
        let pathMatched = false;
        for (const route of this.#routes) {
            const found = route.regex.exec(pathname);
            if (!found) continue;
            pathMatched = true;
            if (route.method !== method) continue;
            const params = Object.fromEntries(
                route.keys.map((key, index) => [key, decodeURIComponent(found[index + 1])])
            );
            return { handler: route.handler, params };
        }
        throw new HTTPError(pathMatched ? 405 : 404, pathMatched ? 'Method not allowed' : 'Not found');
    }
}

export function sendJSON(response, status, body) {
    const payload = JSON.stringify(body);
    response.writeHead(status, {
        'Content-Type': 'application/json; charset=utf-8',
        'Content-Length': Buffer.byteLength(payload),
        'Cache-Control': 'no-store',
    });
    response.end(payload);
}

export function sendEmpty(response, status = 204) {
    response.writeHead(status);
    response.end();
}
