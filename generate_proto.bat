@echo off
setlocal enabledelayedexpansion

set PROTOC_PATH=protoc\protoc.exe
set PROTOC_GEN_GO=protoc\protoc-gen-go.exe
set PROTOC_GEN_GO_GRPC=protoc\protoc-gen-go-grpc.exe

if not exist "%PROTOC_PATH%" (
    echo Error: protoc not found at %PROTOC_PATH%
    exit /b 1
)

if not exist "%PROTOC_GEN_GO%" (
    echo Error: protoc-gen-go not found at %PROTOC_GEN_GO%
    exit /b 1
)

if not exist "%PROTOC_GEN_GO_GRPC%" (
    echo Error: protoc-gen-go-grpc not found at %PROTOC_GEN_GO_GRPC%
    exit /b 1
)

echo Generating protobuf files...

for /r %%f in (*.proto) do (
    set "PROTO_FILE=%%f"
    set "REL_PATH=!PROTO_FILE:%CD%=!"
    set "REL_PATH=!REL_PATH:~1!"
    echo Compiling: !REL_PATH!
    "%PROTOC_PATH%" --proto_path=. --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative --plugin=protoc-gen-go="%PROTOC_GEN_GO%" --plugin=protoc-gen-go-grpc="%PROTOC_GEN_GO_GRPC%" "!REL_PATH!"
    if !errorlevel! neq 0 (
        echo Error: !REL_PATH! failed
        exit /b 1
    )
)

echo All proto files compiled successfully!
