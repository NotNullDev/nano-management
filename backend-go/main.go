package main

import (
	"database/sql"
	"encoding/json"
	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/go-chi/cors"
	"github.com/uptrace/bun"
	"github.com/uptrace/bun/dialect/pgdialect"
	"github.com/uptrace/bun/driver/pgdriver"
	"log"
	"net/http"
	"time"
)

type AppUserEntity struct {
	Id        string    `json:"id" `
	Email     string    `json:"email"`
	FirstName string    `json:"firstName" bun:"firstname"`
	LastName  string    `json:"lastName" bun:"lastname"`
	Role      string    `json:"role"`
	CreatedAt time.Time `json:"createdAt"`
	UpdatedAt time.Time `json:"updatedAt"`
	DeletedAt time.Time `json:"deletedAt"`
}

type ErrorResponse struct {
	Message string `json:"message"`
	Code    string `json:"code"`
}

func main() {
	dsn := "postgres://postgres:postgres@localhost:5432/nanomanagement?sslmode=disable"
	sqldb := sql.OpenDB(pgdriver.NewConnector(pgdriver.WithDSN(dsn)))

	db := bun.NewDB(sqldb, pgdialect.New())

	r := chi.NewRouter()
	r.Use(middleware.Logger)
	r.Use(cors.Handler(cors.Options{
		AllowedOrigins:   []string{"http://localhost:3000"},
		AllowedMethods:   []string{"*"},
		AllowedHeaders:   []string{"*"},
		AllowCredentials: true,
		Debug:            true,
	}))

	r.Get("/", func(w http.ResponseWriter, r *http.Request) {
		var users []AppUserEntity
		err := db.NewRaw("select * from app_user").Scan(r.Context(), &users)
		if err != nil {
			logError(err.Error())
			writeError(w, "Failed to get all users from the database", "DB_ERROR", http.StatusInternalServerError)
			return
		}

		writeResponse(w, users, http.StatusOK)
	})

	err := http.ListenAndServe(":8080", r)
	if err != nil {
		panic(err.Error())
	}
}

func writeError(w http.ResponseWriter, errorMessage string, errorCode string, httpCode int) {
	body := ErrorResponse{
		Message: errorMessage,
		Code:    errorCode,
	}

	bodyBytes, err := json.Marshal(body)
	if err != nil {
		logError(err.Error())
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	w.WriteHeader(httpCode)
	_, err = w.Write(bodyBytes)

	if err != nil {
		logError(err.Error())
	}
}

func writeResponse(w http.ResponseWriter, body interface{}, httpCode int) {
	w.WriteHeader(httpCode)

	if body == nil {
		return
	}

	bodyBytes, err := json.Marshal(body)
	if err != nil {
		logError(err.Error())
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	_, err = w.Write(bodyBytes)

	if err != nil {
		logError(err.Error())
	}
}

func logError(err string) {
	log.Printf("[ERROR] %s", err)
}
