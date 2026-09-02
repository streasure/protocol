#!/bin/bash
set -e

PROTOC_PATH="./protoc/protoc"
PROTOC_GEN_GO="./protoc/protoc-gen-go"
PROTOC_GEN_GO_GRPC="./protoc/protoc-gen-go-grpc"

if [ ! -f "$PROTOC_PATH" ]; then
    echo "Error: protoc not found at $PROTOC_PATH"
    exit 1
fi

if [ ! -f "$PROTOC_GEN_GO" ]; then
    echo "Error: protoc-gen-go not found at $PROTOC_GEN_GO"
    exit 1
fi

if [ ! -f "$PROTOC_GEN_GO_GRPC" ]; then
    echo "Error: protoc-gen-go-grpc not found at $PROTOC_GEN_GO_GRPC"
    exit 1
fi

echo "Generating protobuf files..."

find . -name "*.proto" -not -path "./protoc/*" | while read -r file; do
    echo "Compiling: $file"
    "$PROTOC_PATH" --proto_path=. --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative --plugin=protoc-gen-go="$PROTOC_GEN_GO" --plugin=protoc-gen-go-grpc="$PROTOC_GEN_GO_GRPC" "$file"
done

echo "All proto files compiled successfully!"
