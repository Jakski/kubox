ARG GO_VERSION=1.11
FROM golang:${GO_VERSION}-alpine3.8 as golang

FROM kubox:base
COPY --from=golang /usr/local/go /usr/local
ENV PATH="/usr/local/go/bin:${PATH}"
