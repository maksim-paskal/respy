FROM golang:1.12 as build

COPY main.go /usr/src/respy/main.go
COPY go.mod /usr/src/respy/go.mod
COPY go.sum /usr/src/respy/go.sum

ENV GOOS=linux
ENV GOARCH=amd64
ENV CGO_ENABLED=0

RUN cd /usr/src/respy \
  && go mod download \
  && go mod verify \
  && go build -v -o respy

FROM alpine:latest

COPY --from=build /usr/src/respy/respy /usr/local/bin/respy
RUN apk add --no-cache ca-certificates

CMD respy