package main

import (
	"fmt"
	"log"
	"net/http"
)

func main() {
	http.Handle("/app-one", http.StripPrefix("/app-one", http.FileServer(http.Dir("./app-one"))))

	http.Handle("/app-two", http.StripPrefix("/app-two", http.FileServer(http.Dir("./app-two"))))

	http.Handle("/", http.FileServer(http.Dir("./static")))

	fmt.Printf("Starting server at: http://localhost:3000\n")
	if err := http.ListenAndServe(":3000", nil); err != nil {
		log.Fatal(err)
	}
}
