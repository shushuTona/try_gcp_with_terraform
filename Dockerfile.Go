FROM golang:1.21

RUN apt update -y && apt install zip -y

RUN cd /go/src && mkdir try_gcp_with_terraform

WORKDIR /go/src/try_gcp_with_terraform
