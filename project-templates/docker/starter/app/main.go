package main

import (
	"fmt"
	"log"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		log.Printf("Request from Addr: %s, Host: %s", r.RemoteAddr, r.Host)
		w.Write([]byte("I'm an app!"))
		return
	})

	serveAddr := fmt.Sprintf(":%d", 3000)
	log.Printf("Starting server at: %s\n", serveAddr)
	if err := http.ListenAndServe(serveAddr, nil); err != nil {
		log.Fatal(err)
	}
}
