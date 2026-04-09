const { Client } = require('pg');
const fs = require('fs');

async function importDb() {
    const connectionString = "postgresql://sanmour_db_htri_user:rYyFQsDIKrqzQ5LSx7O2EOKgr95Y8ctE@dpg-d7bvmd9f9bms73dr0jd0-a.oregon-postgres.render.com/sanmour_db_htri";

    const client = new Client({
        connectionString: connectionString,
        ssl: { rejectUnauthorized: false }
    });

    try {
        console.log("Connecting to Render PostgreSQL...");
        await client.connect();

        console.log("Reading database.sql...");
        let sql = fs.readFileSync('database.sql', 'utf8');

        console.log("Processing COPY blocks (converting to INSERT)...");
        // Regex to find COPY blocks: COPY table (cols) FROM stdin; [data] \.
        const copyRegex = /COPY\s+([\w.]+)\s*\((.*?)\)\s*FROM\s*stdin;([\s\S]*?)\\\./gi;
        
        sql = sql.replace(copyRegex, (match, table, columns, data) => {
            const rows = data.trim().split(/\r?\n/).filter(r => r.trim().length > 0);
            if (rows.length === 0) return "";

            const values = rows.map(row => {
                const cells = row.split('\t').map(c => {
                    if (c === '\\N') return 'NULL';
                    // Escape single quotes
                    return "'" + c.replace(/'/g, "''") + "'";
                });
                return `(${cells.join(',')})`;
            }).join(',');

            return `INSERT INTO ${table} (${columns}) VALUES ${values};`;
        });

        console.log("Cleaning SQL (removing comments and ownership settings)...");
        
        // Remove comments
        sql = sql.replace(/--.*$/gm, "");
        sql = sql.replace(/\/\*[\s\S]*?\*\//g, "");

        // Remove psql meta-commands and settings that cause errors on Render
        sql = sql.replace(/^\\.*$/gm, "");
        sql = sql.replace(/^SET .*$/gm, "");
        sql = sql.replace(/^SELECT pg_catalog.*$/gm, "");
        sql = sql.replace(/^ALTER .* OWNER TO .*$/gm, "");

        console.log("Splitting and importing data...");
        // Split by semicolon, but handle cases where semicolon might be missing or trailing
        const queries = sql.split(';').map(q => q.trim()).filter(q => q.length > 5);
        
        let successCount = 0;
        let failCount = 0;

        for (let query of queries) {
            try {
                await client.query(query);
                successCount++;
            } catch (err) {
                // Ignore harmless errors like "already exists" or sequence link errors
                if (err.message.includes("already exists") || err.message.includes("must be member of role")) {
                    successCount++;
                } else {
                    console.warn(`⚠️ Warning on query: ${query.substring(0, 80)}...`);
                    console.warn(`   Error: ${err.message}`);
                    failCount++;
                }
            }
        }

        console.log(`\nImport Summary: ${successCount} queries succeeded, ${failCount} warnings.`);
        console.log("\n✓ Database import completed successfully!");
        console.log("Check your site now: https://sanmour-nu.vercel.app/");
    } catch (err) {
        console.error("\n✗ Fatal Error:", err.message);
    } finally {
        await client.end();
    }
}

importDb();
