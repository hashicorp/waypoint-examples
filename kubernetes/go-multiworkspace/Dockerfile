#--------------------------------------------------------------------
# builder
#--------------------------------------------------------------------

FROM golang:1.17.2-alpine3.14 AS builder

WORKDIR /app-src

COPY go.mod ./
COPY go.sum ./

RUN go mod download

COPY . ./

RUN go build -o /tmp/go-multiworkspace 

#--------------------------------------------------------------------
# final image
#--------------------------------------------------------------------

FROM alpine:3.14

# Config is expected to be delivered here at runtime
RUN mkdir /opt/config

COPY --from=builder /tmp/go-multiworkspace /go-multiworkspace

CMD [ "/go-multiworkspace" ]
