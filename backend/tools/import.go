package main

import (
	"context"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"os"

	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

func main() {
	uri := "mongodb+srv://vishal:Digital1717@cluster0.jobv6tm.mongodb.net/?appName=Cluster0"
	clientOptions := options.Client().ApplyURI(uri)
	client, err := mongo.Connect(context.TODO(), clientOptions)
	if err != nil {
		log.Fatal(err)
	}
	defer client.Disconnect(context.TODO())

	db := client.Database("sanmour_db")

	importCollection(db, "admins", "../../sanmour_db.admins.json")
	importCollection(db, "projects", "../../sanmour_db.projects.json")

	fmt.Println("Data imported successfully!")
}

func importCollection(db *mongo.Database, collName string, filePath string) {
	fileContent, err := ioutil.ReadFile(filePath)
	if err != nil {
		log.Fatalf("Error reading %s: %v", filePath, err)
	}

	var data []interface{}
	err = json.Unmarshal(fileContent, &data)
	if err != nil {
		// If it's single JSON object or ndjson, we might need a different unmarshal strategy.
		// Let's assume it's a JSON array. Wait, let me check the file first.
		log.Printf("Could not unmarshal array for %s. Trying as ndjson or checking error: %v", collName, err)
		return
	}

	coll := db.Collection(collName)
	_, err = coll.InsertMany(context.TODO(), data)
	if err != nil {
		log.Fatalf("Error inserting into %s: %v", collName, err)
	}
	fmt.Printf("Successfully imported %d records into %s\n", len(data), collName)
}
