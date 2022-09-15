package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

func main() {
	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("healthy\n"))
		return
	})

	http.HandleFunc("/hello", func(w http.ResponseWriter, r *http.Request) {
		log.Printf("Hello request from Addr: %s, Host: %s", r.RemoteAddr, r.Host)

		helloMessage := os.Getenv("HELLO_MESSAGE")
		if helloMessage == "" {
			w.Write([]byte("HELLO_MESSAGE env var not set"))
			w.WriteHeader(500)
			return
		}

		w.Write([]byte(helloMessage))
		return
	})

	port := 3000
	serveAddr := fmt.Sprintf(":%d", port)
	log.Printf("Starting server at: %s\n", serveAddr)
	if err := http.ListenAndServe(serveAddr, nil); err != nil {
		log.Fatal(err)
	}
}
