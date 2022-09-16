#--------------------------------------------------------------------
# builder
#--------------------------------------------------------------------

FROM golang:1.18-alpine AS builder

WORKDIR /app-src

COPY go.mod ./

RUN go mod download

COPY . ./

RUN GOOS=linux GOARCH=amd64 go build -tags netgo -ldflags="-w -s" -o /tmp/go-k8s 

#--------------------------------------------------------------------
# final image
#--------------------------------------------------------------------

FROM scratch

COPY --from=builder /tmp/go-k8s /go-k8s
COPY --from=builder /app-src/static /static


CMD [ "/go-k8s" ]
