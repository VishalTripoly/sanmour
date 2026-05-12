const { MongoClient, ObjectId } = require('mongodb');
const fs = require('fs');

async function importData() {
    const uri = "mongodb+srv://vishal:Digital1717@cluster0.jobv6tm.mongodb.net/?appName=Cluster0";
    const client = new MongoClient(uri);

    try {
        await client.connect();
        const db = client.db("sanmour_db");

        // Parse and insert admins
        let admins = JSON.parse(fs.readFileSync('sanmour_db.admins.json', 'utf8'));
        admins = admins.map(doc => {
            if (doc._id && doc._id.$oid) {
                doc._id = new ObjectId(doc._id.$oid);
            }
            return doc;
        });
        if (admins.length > 0) {
            await db.collection("admins").insertMany(admins);
            console.log(`Inserted ${admins.length} admins.`);
        }

        // Parse and insert projects
        let projects = JSON.parse(fs.readFileSync('sanmour_db.projects.json', 'utf8'));
        projects = projects.map(doc => {
            if (doc._id && doc._id.$oid) {
                doc._id = new ObjectId(doc._id.$oid);
            }
            return doc;
        });
        if (projects.length > 0) {
            await db.collection("projects").insertMany(projects);
            console.log(`Inserted ${projects.length} projects.`);
        }

        console.log("All data imported successfully!");
    } catch (e) {
        console.error(e);
    } finally {
        await client.close();
    }
}

importData();
