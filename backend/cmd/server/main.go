package main

import (
	"log"

	"github.com/joho/godotenv"
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"

	"sanmour-backend/internal/db"
	"sanmour-backend/internal/handlers"
	"sanmour-backend/internal/middleware"
)

func main() {
	// Load environment variables from .env
	err := godotenv.Load()
	if err != nil {
		log.Println("No .env file found, using system environment variables")
	}

	// Connect to database
	db.Connect()

	r := gin.Default()

	// Enable CORS for frontend
	r.Use(cors.New(cors.Config{
		AllowOrigins: []string{
			"http://localhost:3000",
			"http://127.0.0.1:3000",
			"https://sanmour-nu.vercel.app",
		},
		AllowMethods:     []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowHeaders:     []string{"Content-Type", "Authorization"},
		ExposeHeaders:    []string{"Content-Length"},
		AllowCredentials: true,
		MaxAge:           12 * 60 * 60,
	}))

	// Static files for uploaded images
	r.Static("/uploads", "./uploads")

	// Serve frontend static files from the Sanmour folder under /site
	r.Static("/site", "../Sanmour")

	// Public routes
	r.POST("/admin/login", handlers.AdminLogin)
	r.GET("/projects", handlers.GetProjects)
	r.GET("/projects/:id", handlers.GetSingleProject)
	r.GET("/projects/:id/images", handlers.GetProjectImages)

	// Protected admin routes (requires JWT token)
	admin := r.Group("/admin")
	admin.Use(middleware.AdminAuth())
	{
		admin.POST("/projects", handlers.AddProject)
		admin.PUT("/projects/:id", handlers.UpdateProject)
		admin.DELETE("/projects/:id", handlers.DeleteProject)
		admin.POST("/projects/:id/images", handlers.AddProjectImages)
		admin.DELETE("/project-images/:id", handlers.DeleteProjectImage)
	}

	// Start server
	r.Run(":8080")
}