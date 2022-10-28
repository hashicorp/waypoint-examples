package main

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"
	"os"
	"strconv"

	_ "github.com/lib/pq"
)

func main() {
	http.HandleFunc("/", connect)
	err := http.ListenAndServe(":80", nil)
	if err != nil {
		return
	}
}

func connect(w http.ResponseWriter, r *http.Request) {
	type conn struct {
		user     string
		password string
		port     int
		host     string
		dbname   string
	}

	port, err := strconv.Atoi(os.Getenv("PORT"))
	if err != nil {
		log.Fatal(err)
	}
	connection := conn{
		user:     os.Getenv("USERNAME"),
		password: os.Getenv("PASSWORD"),
		port:     port,
		host:     os.Getenv("HOST"),
		dbname:   os.Getenv("DBNAME"),
	}

	psqlInfo := fmt.Sprintf("host=%s port=%d user=%s "+
		"password=%s dbname=%s sslmode=disable",
		connection.host, connection.port, connection.user, connection.password, connection.dbname)
	db, err := sql.Open("postgres", psqlInfo)
	if err != nil {
		panic(err)
	}
	defer db.Close()

	err = db.Ping()
	if err != nil {
		log.Fatal(err)
	}

	fmt.Print("Hello, database! Connected to " + connection.host)
	log.Println("Successfully connected to the database! :)")
}
