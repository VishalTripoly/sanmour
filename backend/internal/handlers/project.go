package handlers

import (
	"database/sql"
	"fmt"           // Used for formatted strings (file names)
	"log"           // Used for logging errors
	"os"            // Used to delete image files from system
	"path/filepath" // Used to safely build file paths
	"strings"       // Used for trimming and sanitizing strings
	"time"          // Used to generate unique timestamps

	// Database connection
	"sanmour-backend/internal/db"

	// Gin framework
	"github.com/gin-gonic/gin"
)

/* =====================================================
   ADD PROJECT
   - Handles creation of a new project
   - Accepts form data + thumbnail image
   - Saves thumbnail in /uploads
   - Inserts project record into database
===================================================== */

func AddProject(c *gin.Context) {

	// --------------------------
	// Read form values
	// --------------------------
	projectType := strings.TrimSpace(c.PostForm("project_type"))
	projectName := strings.TrimSpace(c.PostForm("project_name"))
	status := strings.TrimSpace(c.PostForm("status"))
	description := strings.TrimSpace(c.PostForm("description"))

	// NEW optional fields
	clientName := strings.TrimSpace(c.PostForm("client_name"))
	location := strings.TrimSpace(c.PostForm("location"))

	// --------------------------
	// Normalize project type
	// Fixes issues like: "Independent Bungalows / Villa"
	// Converts "/" to "-" for DB safety
	// --------------------------
	projectType = strings.ReplaceAll(projectType, "/", "-")

	// --------------------------
	// Validate required fields
	// --------------------------
	if projectName == "" || projectType == "" || description == "" {
		c.JSON(400, gin.H{"error": "Project name, type and description are required"})
		return
	}

	// --------------------------
	// Get uploaded thumbnail image
	// --------------------------
	file, err := c.FormFile("thumbnail")
	if err != nil {
		c.JSON(400, gin.H{"error": "Thumbnail image is required"})
		return
	}

	// --------------------------
	// Validate file size (max 5MB)
	// --------------------------
	//if file.Size > 5*1024*1024 {
	//	c.JSON(400, gin.H{"error": "File size must be less than 5MB"})
	//	return
	//}

	// --------------------------
	// Generate unique filename
	// Prevents overwriting existing files
	// --------------------------
	filename := fmt.Sprintf("%d_%s", time.Now().UnixNano(), file.Filename)
	path := filepath.Join("uploads", filename)

	// --------------------------
	// Save thumbnail to uploads folder
	// --------------------------
	if err := c.SaveUploadedFile(file, path); err != nil {
		log.Println("File save error:", err)
		c.JSON(500, gin.H{"error": "Failed to save thumbnail"})
		return
	}

	// --------------------------
	// Insert project into database
	// --------------------------
	_, err = db.DB.Exec(`
       INSERT INTO projects
       (project_name, project_type, description, thumbnail, status,
       client_name, location)
       VALUES ($1,$2,$3,$4,$5,$6,$7)
   `,
		projectName,
		projectType,
		description,
		path,
		status,
		clientName,
		location,
	)

	// --------------------------
	// Handle DB insertion error
	// --------------------------
	if err != nil {
		log.Println("DB insert error:", err)
		c.JSON(500, gin.H{"error": "Failed to insert project"})
		return
	}

	// --------------------------
	// Success response
	// --------------------------
	c.JSON(201, gin.H{"message": "Project added successfully"})
}

/* =====================================================
   GET ALL PROJECTS
   - Returns all projects
   - Ordered by latest first
   - Used by admin & portfolio page
===================================================== */

func GetProjects(c *gin.Context) {

	// --------------------------
	// Fetch all projects from DB
	// --------------------------
	rows, err := db.DB.Query(
		`SELECT id, project_name, project_type, description, thumbnail 
		 FROM projects ORDER BY created_at DESC`,
	)
	if err != nil {
		c.JSON(500, gin.H{"error": "Database error"})
		return
	}
	defer rows.Close()

	// --------------------------
	// Slice to store projects
	// --------------------------
	var projects []gin.H

	// --------------------------
	// Iterate through rows
	// --------------------------
	for rows.Next() {
		var id int
		var name, ptype, desc, thumb string
		rows.Scan(&id, &name, &ptype, &desc, &thumb)

		projects = append(projects, gin.H{
			"id": id, "name": name, "type": ptype,
			"description": desc, "thumbnail": thumb,
		})
	}

	if projects == nil {
		projects = []gin.H{}
	}

	c.JSON(200, projects)
}

/*for rows.Next() {
		var id int
		var name, projectType, description, thumbnail string

		if err := rows.Scan(&id, &name, &projectType, &description, &thumbnail); err != nil {
			continue
		}

		projects = append(projects, gin.H{
			"id":          id,
			"name":        name,
			"type":        projectType,
			"description": description,
			"thumbnail":   thumbnail,
		})
	}

	// --------------------------
	// Return empty array if no projects
	// --------------------------
	if projects == nil {
		projects = []gin.H{}
	}

	c.JSON(200, projects)
}*/

/* =====================================================
   DELETE PROJECT
   - Deletes project by ID
===================================================== */

func DeleteProject(c *gin.Context) {

	// --------------------------
	// Get project ID from URL
	// --------------------------
	projectID := c.Param("id")

	// --------------------------
	// Execute delete query
	// --------------------------
	result, err := db.DB.Exec("DELETE FROM projects WHERE id=$1", projectID)
	if err != nil {
		c.JSON(500, gin.H{"error": "DB error"})
		return
	}

	// --------------------------
	// Check if project existed
	// --------------------------
	count, _ := result.RowsAffected()
	if count == 0 {
		c.JSON(404, gin.H{"error": "Project not found"})
		return
	}

	c.JSON(200, gin.H{"message": "Project deleted"})
}

/* =====================================================
   UPDATE PROJECT
   - Updates project details
   - Optional thumbnail update
===================================================== */

func UpdateProject(c *gin.Context) {

	// --------------------------
	// Get project ID
	// --------------------------
	projectID := c.Param("id")

	// --------------------------
	// Read form values
	// --------------------------
	projectName := strings.TrimSpace(c.PostForm("name"))
	projectType := strings.TrimSpace(c.PostForm("project_type"))
	description := strings.TrimSpace(c.PostForm("description"))

	client := strings.TrimSpace(c.PostForm("client"))
	location := strings.TrimSpace(c.PostForm("location"))

	// Normalize project type
	projectType = strings.ReplaceAll(projectType, "/", "-")

	// --------------------------
	// Check if new thumbnail uploaded
	// --------------------------
	file, err := c.FormFile("thumbnail")

	var thumbnailPath string

	if err == nil {

		// Generate unique filename
		filename := fmt.Sprintf("%d_%s", time.Now().UnixNano(), file.Filename)
		path := filepath.Join("uploads", filename)

		// Save file
		if err := c.SaveUploadedFile(file, path); err != nil {
			c.JSON(500, gin.H{"error": "Failed to save thumbnail"})
			return
		}

		thumbnailPath = path
	}

	// --------------------------
	// Update database
	// --------------------------

	if thumbnailPath != "" {

		// Update including thumbnail
		_, err = db.DB.Exec(`
			UPDATE projects
			SET project_name=$1,
			    project_type=$2,
			    description=$3,
			    client_name=$4,
			    location=$5,
			    thumbnail=$6
			WHERE id=$7
		`,
			projectName,
			projectType,
			description,
			client,
			location,
			thumbnailPath,
			projectID,
		)

	} else {

		// Update without thumbnail
		_, err = db.DB.Exec(`
			UPDATE projects
			SET project_name=$1,
			    project_type=$2,
			    description=$3,
			    client_name=$4,
			    location=$5
			WHERE id=$6
		`,
			projectName,
			projectType,
			description,
			client,
			location,
			projectID,
		)
	}

	if err != nil {
		log.Println("Update error:", err)
		c.JSON(500, gin.H{"error": "Failed to update project"})
		return
	}

	c.JSON(200, gin.H{"message": "Project updated successfully"})
}

/* =====================================================
   GET SINGLE PROJECT
   - Fetch project details by ID
===================================================== */

func GetSingleProject(c *gin.Context) {

	// --------------------------
	// Get project ID
	// --------------------------
	id := c.Param("id")

	// --------------------------
	// Struct to store project data
	// --------------------------
	var (
		clientName, location, status sql.NullString
	)

	var project struct {
		ID          int            `json:"id"`
		Name        string         `json:"name"`
		Type        string         `json:"type"`
		Status      string         `json:"status"`
		ClientName  string         `json:"client_name"`
		Location    string         `json:"location"`
		Description string         `json:"description"`
		Thumbnail   string         `json:"thumbnail"`
		Gallery     []GalleryImage `json:"gallery"`
	}

	// --------------------------
	// Fetch project from DB
	// --------------------------
	err := db.DB.QueryRow(`
		SELECT id, project_name, project_type, status,
		       client_name, location,
		       description, thumbnail
		FROM projects WHERE id=$1
	`, id).Scan(
		&project.ID,
		&project.Name,
		&project.Type,
		&status,
		&clientName,
		&location,
		&project.Description,
		&project.Thumbnail,
	)

	// --------------------------
	// Handle not found
	// --------------------------
	if err != nil {
		c.JSON(404, gin.H{"error": "Project not found"})
		return
	}
	// Convert NULL → empty string
	project.Status = status.String
	project.ClientName = clientName.String
	project.Location = location.String

	c.JSON(200, project)
}

/* =====================================================
   ADD PROJECT GALLERY IMAGES
   - Upload multiple images for a project
===================================================== */

type GalleryImage struct {
	ID        int    `json:"id"`
	ImagePath string `json:"image_path"`
}

func AddProjectImages(c *gin.Context) {

	// --------------------------
	// Get project ID
	// --------------------------
	projectID := c.Param("id")

	// --------------------------
	// Parse multipart form
	// --------------------------
	form, err := c.MultipartForm()
	if err != nil {
		c.JSON(400, gin.H{"error": "Invalid form"})
		return
	}

	// --------------------------
	// Get uploaded images
	// --------------------------
	files := form.File["images"]

	// --------------------------
	// Loop through images
	// --------------------------
	for _, file := range files {

		// Generate unique filename
		filename := fmt.Sprintf("%d_%s", time.Now().UnixNano(), file.Filename)
		path := filepath.Join("uploads", filename)

		// Save image file
		if err := c.SaveUploadedFile(file, path); err != nil {
			log.Println(err)
			continue
		}

		// Insert image record
		db.DB.Exec(
			`INSERT INTO project_images (project_id, image_path)
			 VALUES ($1, $2)`,
			projectID, path,
		)
	}

	c.JSON(200, gin.H{"message": "Images uploaded"})
}

/* =====================================================
   GET PROJECT GALLERY IMAGES
   - Returns gallery images for a project
===================================================== */

func GetProjectImages(c *gin.Context) {

	// --------------------------
	// Get project ID
	// --------------------------
	id := c.Param("id")

	// --------------------------
	// Fetch images from DB
	// --------------------------
	rows, err := db.DB.Query(
		`SELECT id, image_path FROM project_images WHERE project_id=$1`,
		id,
	)
	if err != nil {
		c.JSON(500, gin.H{"error": "DB error"})
		return
	}
	defer rows.Close()

	var images []GalleryImage

	// --------------------------
	// Read DB rows
	// --------------------------
	for rows.Next() {
		var img GalleryImage
		rows.Scan(&img.ID, &img.ImagePath)
		images = append(images, img)
	}

	// --------------------------
	// Return empty array if none
	// --------------------------
	if images == nil {
		images = []GalleryImage{}
	}

	c.JSON(200, images)
}

/* =====================================================
   DELETE PROJECT GALLERY IMAGE
   - Deletes image file + DB record
===================================================== */

func DeleteProjectImage(c *gin.Context) {

	// --------------------------
	// Get image ID
	// --------------------------
	imageID := c.Param("id")

	var imagePath string

	// --------------------------
	// Fetch image path
	// --------------------------
	err := db.DB.QueryRow(
		`SELECT image_path FROM project_images WHERE id=$1`,
		imageID,
	).Scan(&imagePath)

	if err != nil {
		c.JSON(404, gin.H{"error": "Image not found"})
		return
	}

	// --------------------------
	// Delete file from system
	// --------------------------
	_ = os.Remove(imagePath)

	// --------------------------
	// Delete DB record
	// --------------------------
	db.DB.Exec(
		`DELETE FROM project_images WHERE id=$1`,
		imageID,
	)

	c.JSON(200, gin.H{"message": "Image deleted"})
}
