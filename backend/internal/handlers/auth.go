package handlers

import (
	"context"
	"os"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
	"golang.org/x/crypto/bcrypt"

	"go.mongodb.org/mongo-driver/bson"

	"sanmour-backend/internal/db"
)

var jwtKey = []byte(os.Getenv("JWT_SECRET"))

func AdminLogin(c *gin.Context) {

	var req struct {
		Email    string `json:"email"`
		Password string `json:"password"`
	}

	c.BindJSON(&req)

	// MongoDB collection
	collection := db.DB.Collection("admins")

	// Admin structure
	var admin struct {
		Email    string `bson:"email"`
		Password string `bson:"password"`
	}

	// Find admin by email
	err := collection.FindOne(
		context.TODO(),
		bson.M{"email": req.Email},
	).Decode(&admin)

	if err != nil {
		c.JSON(401, gin.H{"error": "Invalid credentials"})
		return
	}

	// Compare password
	err = bcrypt.CompareHashAndPassword(
		[]byte(admin.Password),
		[]byte(req.Password),
	)

	if err != nil {
		c.JSON(401, gin.H{"error": "Wrong password"})
		return
	}

	// Generate JWT token
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"email": req.Email,
		"exp":   time.Now().Add(24 * time.Hour).Unix(),
	})

	tokenStr, _ := token.SignedString(jwtKey)

	c.JSON(200, gin.H{
		"token": tokenStr,
	})
}