package db

import (
	"database/sql"
	"log"
	"os"

	_ "github.com/lib/pq"
)

var DB *sql.DB

func Connect() {

	// Read connection string from environment variable
	conn := os.Getenv("DATABASE_URL")

	if conn == "" {
		log.Fatal("DATABASE_URL not set")
	}

	database, err := sql.Open("postgres", conn)
	if err != nil {
		log.Fatal("Failed to connect to database:", err)
	}

	err = database.Ping()
	if err != nil {
		log.Fatal("Failed to ping database:", err)
	}

	DB = database
	log.Println("✓ Connected to PostgreSQL successfully")
}
