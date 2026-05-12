package handlers

import (
	
	"fmt"           // Used for formatted strings (file names)
	"log"           // Used for logging errors
	"os"            // Used to delete image files from system
	"path/filepath" // Used to safely build file paths
	"strings"       // Used for trimming and sanitizing strings
	"time"          // Used to generate unique timestamps

	"context"

    "go.mongodb.org/mongo-driver/bson"
    "go.mongodb.org/mongo-driver/bson/primitive"

	// Database connection
	"sanmour-backend/internal/db"

	// Gin framework
	"github.com/gin-gonic/gin"
)

type Project struct {
	ID          primitive.ObjectID `bson:"_id,omitempty" json:"id"`
	ProjectName string             `bson:"project_name" json:"project_name"`
	ProjectType string             `bson:"project_type" json:"project_type"`
	Description string             `bson:"description" json:"description"`
	Thumbnail   string             `bson:"thumbnail" json:"thumbnail"`
	Status      string             `bson:"status" json:"status"`
	ClientName  string             `bson:"client_name" json:"client_name"`
	Location    string             `bson:"location" json:"location"`
	CreatedAt   time.Time          `bson:"created_at" json:"created_at"`
}

/* =====================================================
   ADD PROJECT
   - Handles creation of a new project
   - Accepts form data + thumbnail image
   - Saves thumbnail in /uploads
   - Inserts project record into database
===================================================== */

func AddProject(c *gin.Context) {

	projectType := strings.TrimSpace(c.PostForm("project_type"))
	projectName := strings.TrimSpace(c.PostForm("project_name"))
	status := strings.TrimSpace(c.PostForm("status"))
	description := strings.TrimSpace(c.PostForm("description"))

	clientName := strings.TrimSpace(c.PostForm("client_name"))
	location := strings.TrimSpace(c.PostForm("location"))

	projectType = strings.ReplaceAll(projectType, "/", "-")

	if projectName == "" || projectType == "" || description == "" {
		c.JSON(400, gin.H{"error": "Project name, type and description are required"})
		return
	}

	file, err := c.FormFile("thumbnail")
	if err != nil {
		c.JSON(400, gin.H{"error": "Thumbnail image is required"})
		return
	}

	filename := fmt.Sprintf("%d_%s", time.Now().UnixNano(), file.Filename)
	path := filepath.Join("uploads", filename)

	if err := c.SaveUploadedFile(file, path); err != nil {
		log.Println("File save error:", err)
		c.JSON(500, gin.H{"error": "Failed to save thumbnail"})
		return
	}

	// MongoDB collection
	collection := db.DB.Collection("projects")

	project := Project{
		ProjectName: projectName,
		ProjectType: projectType,
		Description: description,
		Thumbnail:   path,
		Status:      status,
		ClientName:  clientName,
		Location:    location,
		CreatedAt:   time.Now(),
	}

	_, err = collection.InsertOne(context.TODO(), project)

	if err != nil {
		log.Println("Mongo insert error:", err)
		c.JSON(500, gin.H{"error": "Failed to insert project"})
		return
	}

	c.JSON(201, gin.H{
		"message": "Project added successfully",
	})
}

/* =====================================================
   GET ALL PROJECTS
   - Returns all projects
===================================================== */

func GetProjects(c *gin.Context) {

	// =====================================================
	// MONGODB COLLECTION
	// =====================================================

	collection := db.DB.Collection("projects")

	// =====================================================
	// FIND ALL PROJECTS
	// =====================================================

	cursor, err := collection.Find(
		context.TODO(),
		bson.M{},
	)

	if err != nil {
		c.JSON(500, gin.H{
			"error": "Database error",
		})
		return
	}

	defer cursor.Close(context.TODO())

	// =====================================================
	// STORE PROJECTS
	// =====================================================

	var projects []Project

	// Read MongoDB documents
	for cursor.Next(context.TODO()) {

		var project Project

		err := cursor.Decode(&project)
		if err != nil {
			continue
		}

		projects = append(projects, project)
	}

	// =====================================================
	// RETURN EMPTY ARRAY IF NO PROJECTS
	// =====================================================

	if projects == nil {
		projects = []Project{}
	}

	// =====================================================
	// RETURN RESPONSE
	// =====================================================

	c.JSON(200, projects)
}


/* =====================================================
   DELETE PROJECT
   - Deletes project by ID
===================================================== */

func DeleteProject(c *gin.Context) {

	// Get project ID from URL
	projectID := c.Param("id")

	// Convert string ID -> MongoDB ObjectID
	objectID, err := primitive.ObjectIDFromHex(projectID)
	if err != nil {
		c.JSON(400, gin.H{"error": "Invalid project ID"})
		return
	}

	// MongoDB collection
	collection := db.DB.Collection("projects")

	// Delete project
	result, err := collection.DeleteOne(
		context.TODO(),
		bson.M{"_id": objectID},
	)

	if err != nil {
		c.JSON(500, gin.H{"error": "Database error"})
		return
	}

	// Check if project existed
	if result.DeletedCount == 0 {
		c.JSON(404, gin.H{"error": "Project not found"})
		return
	}

	c.JSON(200, gin.H{
		"message": "Project deleted successfully",
	})
}

/* =====================================================
   UPDATE PROJECT
   - Updates project details
   - Optional thumbnail update
===================================================== */

func UpdateProject(c *gin.Context) {

	// =====================================================
	// GET PROJECT ID FROM URL
	// =====================================================

	projectID := c.Param("id")

	// Convert string ID into MongoDB ObjectID
	objectID, err := primitive.ObjectIDFromHex(projectID)
	if err != nil {
		c.JSON(400, gin.H{"error": "Invalid project ID"})
		return
	}

	// =====================================================
	// READ FORM VALUES
	// =====================================================

	projectName := strings.TrimSpace(c.PostForm("name"))
	projectType := strings.TrimSpace(c.PostForm("project_type"))
	description := strings.TrimSpace(c.PostForm("description"))

	client := strings.TrimSpace(c.PostForm("client"))
	location := strings.TrimSpace(c.PostForm("location"))

	// Normalize project type
	projectType = strings.ReplaceAll(projectType, "/", "-")

	// =====================================================
	// CHECK IF NEW THUMBNAIL IMAGE IS UPLOADED
	// =====================================================

	file, err := c.FormFile("thumbnail")

	var thumbnailPath string

	// If thumbnail exists
	if err == nil {

		// Generate unique filename
		filename := fmt.Sprintf("%d_%s", time.Now().UnixNano(), file.Filename)

		// Build uploads path
		path := filepath.Join("uploads", filename)

		// Save image file
		if err := c.SaveUploadedFile(file, path); err != nil {
			c.JSON(500, gin.H{"error": "Failed to save thumbnail"})
			return
		}

		thumbnailPath = path
	}

	// =====================================================
	// MONGODB COLLECTION
	// =====================================================

	collection := db.DB.Collection("projects")

	// =====================================================
	// CREATE UPDATE DATA
	// =====================================================

	updateData := bson.M{
		"project_name": projectName,
		"project_type": projectType,
		"description":  description,
		"client_name":  client,
		"location":     location,
	}

	// Add thumbnail only if uploaded
	if thumbnailPath != "" {
		updateData["thumbnail"] = thumbnailPath
	}

	// =====================================================
	// UPDATE PROJECT IN MONGODB
	// =====================================================

	result, err := collection.UpdateOne(
		context.TODO(),
		bson.M{"_id": objectID},
		bson.M{
			"$set": updateData,
		},
	)

	if err != nil {
		log.Println("Mongo update error:", err)

		c.JSON(500, gin.H{
			"error": "Failed to update project",
		})

		return
	}

	// =====================================================
	// CHECK IF PROJECT EXISTS
	// =====================================================

	if result.MatchedCount == 0 {
		c.JSON(404, gin.H{
			"error": "Project not found",
		})
		return
	}

	// =====================================================
	// SUCCESS RESPONSE
	// =====================================================

	c.JSON(200, gin.H{
		"message": "Project updated successfully",
	})
}

func GetSingleProject(c *gin.Context) {

	// =====================================================
	// GET PROJECT ID FROM URL
	// =====================================================

	id := c.Param("id")

	// Convert string ID -> MongoDB ObjectID
	objectID, err := primitive.ObjectIDFromHex(id)
	if err != nil {
		c.JSON(400, gin.H{"error": "Invalid project ID"})
		return
	}

	// =====================================================
	// MONGODB COLLECTION
	// =====================================================

	collection := db.DB.Collection("projects")

	// =====================================================
	// STRUCT TO STORE PROJECT
	// =====================================================

	var project Project

	// =====================================================
	// FIND PROJECT BY ID
	// =====================================================

	err = collection.FindOne(
		context.TODO(),
		bson.M{"_id": objectID},
	).Decode(&project)

	// =====================================================
	// HANDLE PROJECT NOT FOUND
	// =====================================================

	if err != nil {
		c.JSON(404, gin.H{
			"error": "Project not found",
		})
		return
	}

	// =====================================================
	// RETURN PROJECT
	// =====================================================

	c.JSON(200, project)
}

/* =====================================================
   ADD PROJECT GALLERY IMAGES
   - Upload multiple images for a project
===================================================== */

type GalleryImage struct {
	ID        primitive.ObjectID `bson:"_id,omitempty" json:"id"`
	ProjectID primitive.ObjectID `bson:"project_id" json:"project_id"`
	ImagePath string             `bson:"image_path" json:"image_path"`
}

func AddProjectImages(c *gin.Context) {

	// =====================================================
	// GET PROJECT ID FROM URL
	// =====================================================

	projectID := c.Param("id")

	// Convert string ID -> MongoDB ObjectID
	objectID, err := primitive.ObjectIDFromHex(projectID)
	if err != nil {
		c.JSON(400, gin.H{"error": "Invalid project ID"})
		return
	}

	// =====================================================
	// PARSE MULTIPART FORM
	// =====================================================

	form, err := c.MultipartForm()
	if err != nil {
		c.JSON(400, gin.H{"error": "Invalid form"})
		return
	}

	// =====================================================
	// GET UPLOADED IMAGES
	// =====================================================

	files := form.File["images"]

	// MongoDB collection
	collection := db.DB.Collection("project_images")

	// =====================================================
	// LOOP THROUGH FILES
	// =====================================================

	for _, file := range files {

		// Generate unique filename
		filename := fmt.Sprintf(
			"%d_%s",
			time.Now().UnixNano(),
			file.Filename,
		)

		// Upload path
		path := filepath.Join("uploads", filename)

		// Save uploaded file
		if err := c.SaveUploadedFile(file, path); err != nil {
			log.Println(err)
			continue
		}

		// =====================================================
		// CREATE IMAGE DOCUMENT
		// =====================================================

		image := GalleryImage{
			ProjectID: objectID,
			ImagePath: path,
		}

		// Insert into MongoDB
		_, err := collection.InsertOne(
			context.TODO(),
			image,
		)

		if err != nil {
			log.Println("Mongo insert image error:", err)
		}
	}

	// =====================================================
	// SUCCESS RESPONSE
	// =====================================================

	c.JSON(200, gin.H{
		"message": "Images uploaded successfully",
	})
}

/* =====================================================
   GET PROJECT GALLERY IMAGES
   - Returns gallery images for a project
===================================================== */

func GetProjectImages(c *gin.Context) {

	// =====================================================
	// GET PROJECT ID FROM URL
	// =====================================================

	id := c.Param("id")

	// Convert string ID -> MongoDB ObjectID
	objectID, err := primitive.ObjectIDFromHex(id)
	if err != nil {
		c.JSON(400, gin.H{"error": "Invalid project ID"})
		return
	}

	// =====================================================
	// MONGODB COLLECTION
	// =====================================================

	collection := db.DB.Collection("project_images")

	// =====================================================
	// FIND ALL IMAGES FOR PROJECT
	// =====================================================

	cursor, err := collection.Find(
		context.TODO(),
		bson.M{
			"project_id": objectID,
		},
	)

	if err != nil {
		c.JSON(500, gin.H{"error": "Database error"})
		return
	}

	defer cursor.Close(context.TODO())

	// =====================================================
	// STORE IMAGES
	// =====================================================

	var images []GalleryImage

	// Read MongoDB documents
	for cursor.Next(context.TODO()) {

		var image GalleryImage

		err := cursor.Decode(&image)
		if err != nil {
			continue
		}

		images = append(images, image)
	}

	// =====================================================
	// RETURN EMPTY ARRAY IF NO IMAGES
	// =====================================================

	if images == nil {
		images = []GalleryImage{}
	}

	// =====================================================
	// RETURN RESPONSE
	// =====================================================

	c.JSON(200, images)
}

/* =====================================================
   DELETE PROJECT GALLERY IMAGE
   - Deletes image file + DB record
===================================================== */

func DeleteProjectImage(c *gin.Context) {

	// =====================================================
	// GET IMAGE ID FROM URL
	// =====================================================

	imageID := c.Param("id")

	// Convert string ID -> MongoDB ObjectID
	objectID, err := primitive.ObjectIDFromHex(imageID)
	if err != nil {
		c.JSON(400, gin.H{"error": "Invalid image ID"})
		return
	}

	// =====================================================
	// MONGODB COLLECTION
	// =====================================================

	collection := db.DB.Collection("project_images")

	// =====================================================
	// FIND IMAGE DOCUMENT
	// =====================================================

	var image GalleryImage

	err = collection.FindOne(
		context.TODO(),
		bson.M{
			"_id": objectID,
		},
	).Decode(&image)

	if err != nil {
		c.JSON(404, gin.H{
			"error": "Image not found",
		})
		return
	}

	// =====================================================
	// DELETE IMAGE FILE FROM SYSTEM
	// =====================================================

	_ = os.Remove(image.ImagePath)

	// =====================================================
	// DELETE IMAGE DOCUMENT FROM MONGODB
	// =====================================================

	_, err = collection.DeleteOne(
		context.TODO(),
		bson.M{
			"_id": objectID,
		},
	)

	if err != nil {
		c.JSON(500, gin.H{
			"error": "Failed to delete image",
		})
		return
	}

	// =====================================================
	// SUCCESS RESPONSE
	// =====================================================

	c.JSON(200, gin.H{
		"message": "Image deleted successfully",
	})
}
