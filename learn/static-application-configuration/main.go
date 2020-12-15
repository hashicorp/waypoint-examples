package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

func main() {
	http.HandleFunc("/", saleViewHandler)

	fmt.Printf("Starting server at: http://localhost:3000\n")
	if err := http.ListenAndServe(":3000", nil); err != nil {
		log.Fatal(err)
	}
}

func saleViewHandler(w http.ResponseWriter, r *http.Request) {
	salePercent := os.Getenv("SALE_PERCENT")
	saleEndsOn := os.Getenv("SALE_ENDS_ON")
	fmt.Fprintf(w, `
	<style>body { font-size: 3em; }</style>
	<h1>Today&#8217;s Sale</h1>
	<div>Save %s!</div>
	<div>Until %s</div>
	`,
		salePercent,
		saleEndsOn)
}
