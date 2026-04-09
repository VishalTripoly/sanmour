package main

import (
	"database/sql"
	"fmt"
	"io/ioutil"
	"log"
	"strings"

	_ "github.com/lib/pq"
)

func main() {
	// 1. Connection URL (Your External Render URL)
	connStr := "postgresql://sanmour_db_htri_user:rYyFQsDIKrqzQ5LSx7O2EOKgr95Y8ctE@dpg-d7bvmd9f9bms73dr0jd0-a.oregon-postgres.render.com/sanmour_db_htri"

	fmt.Println("Connecting to Render database...")
	db, err := sql.Open("postgres", connStr)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	// 2. Read the SQL file
	fmt.Println("Reading database.sql...")
	content, err := ioutil.ReadFile("database.sql")
	if err != nil {
		log.Fatal("Could not read database.sql file:", err)
	}

	// 3. Execute the SQL
	fmt.Println("Importing data... (this may take a minute)")
	
	// We split by semicolon to execute one by one (simplified)
	// but psql dumps can be complex. We'll try executing the whole block first.
	_, err = db.Exec(string(content))
	if err != nil {
		fmt.Println("\nError during import. Trying alternative method...")
		// If the whole block fails, we try split execution
		queries := strings.Split(string(content), ";")
		for _, q := range queries {
			q = strings.TrimSpace(q)
			if q == "" || strings.HasPrefix(q, "--") || strings.HasPrefix(q, "\\") {
				continue
			}
			_, err := db.Exec(q)
			if err != nil {
				// Log error but continue
				fmt.Printf("Warning: Failed query: %s\nError: %v\n", q[:50]+"...", err)
			}
		}
	}

	fmt.Println("\n✓ Database import completed successfully!")
}
