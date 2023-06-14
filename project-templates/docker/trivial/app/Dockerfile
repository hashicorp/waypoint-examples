FROM golang:1.20.5-alpine3.18

COPY . ./

RUN go build -o /app main.go

CMD [ "/app" ]