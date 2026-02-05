#!/bin/bash

rm -rf ./proto_go

mkdir -p ./proto_go

find proto -name "*.proto" -type f | while read file; do
  protoc -I proto "$file" \
    --go_out=paths=source_relative:./proto_go \
    --go-grpc_out=paths=source_relative:./proto_go
done
