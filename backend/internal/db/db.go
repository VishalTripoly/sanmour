package db

import (
	"context"
	"log"
	"os"
	"time"

	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

var DB *mongo.Database

func Connect() {

	// Read MongoDB URI from environment variable
	mongoURI := os.Getenv("MONGO_URI")

	// Read database name
	databaseName := os.Getenv("DATABASE_NAME")

	if mongoURI == "" {
		log.Fatal("MONGO_URI not set")
	}

	if databaseName == "" {
		log.Fatal("DATABASE_NAME not set")
	}

	// MongoDB client options
	clientOptions := options.Client().ApplyURI(mongoURI)

	// Context timeout
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	// Connect to MongoDB
	client, err := mongo.Connect(ctx, clientOptions)
	if err != nil {
		log.Fatal("Failed to connect to MongoDB:", err)
	}

	// Ping database
	err = client.Ping(ctx, nil)
	if err != nil {
		log.Fatal("Failed to ping MongoDB:", err)
	}

	// Set global DB variable
	DB = client.Database(databaseName)

	log.Println("✓ Connected to MongoDB successfully")
}