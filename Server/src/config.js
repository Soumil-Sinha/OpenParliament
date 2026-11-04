//
//  config.js
//  OpenParliament Server
//
//  Every setting comes from the environment with a local-development default,
//  so `npm start` works against a stock Homebrew PostgreSQL without a .env.
//  The pg driver reads PGHOST, PGPORT, PGUSER and PGPASSWORD on its own.
//

export const config = {
    port: Number(process.env.PORT ?? 8080),
    host: process.env.HOST ?? '0.0.0.0',
    database: process.env.PGDATABASE ?? 'openparliament',
};
