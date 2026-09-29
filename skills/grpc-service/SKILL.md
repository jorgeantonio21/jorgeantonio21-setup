---
name: grpc-service
description: >
  gRPC service conventions using tonic and prost in Rust. Auto-loaded
  when creating or modifying gRPC services, protobuf definitions, or
  tonic-build configurations.
---

## Stack

- `tonic` — gRPC server and client framework
- `prost` — protobuf code generation
- `tonic-build` — build-time proto compilation (in `build.rs`)

## Proto file placement

Proto files live alongside the crate that owns the service:

```
lib/
└── grpc-client/
    ├── proto/
    │   └── service.proto
    ├── build.rs
    ├── src/
    │   └── lib.rs
    └── Cargo.toml
```

## build.rs setup

```rust
fn main() -> Result<(), Box<dyn std::error::Error>> {
    tonic_build::configure()
        .build_server(true)
        .build_client(true)
        .compile_protos(&["proto/service.proto"], &["proto/"])?;
    Ok(())
}
```

## Service naming

Follow standard gRPC naming conventions:

```protobuf
syntax = "proto3";
package myproject.v1;

service FooService {
    rpc GetFoo(GetFooRequest) returns (GetFooResponse);
    rpc ListFoos(ListFoosRequest) returns (ListFoosResponse);
    rpc CreateFoo(CreateFooRequest) returns (CreateFooResponse);
}
```

- Package name: `<project>.<version>`
- Service name: `<Entity>Service`
- RPC name: `<Verb><Entity>`
- Request/Response: `<RpcName>Request` / `<RpcName>Response`

## Implementation pattern

```rust
use tonic::{Request, Response, Status};

#[tonic::async_trait]
impl FooService for MyFooService {
    async fn get_foo(
        &self,
        request: Request<GetFooRequest>,
    ) -> Result<Response<GetFooResponse>, Status> {
        let inner = request.into_inner();
        // ...
        Ok(Response::new(GetFooResponse { /* ... */ }))
    }
}
```

## Error handling

Map domain errors to `tonic::Status` codes:

| Domain error | gRPC status |
|---|---|
| Not found | `Status::not_found()` |
| Invalid input | `Status::invalid_argument()` |
| Auth failure | `Status::unauthenticated()` |
| Permission denied | `Status::permission_denied()` |
| Internal error | `Status::internal()` |

## Dependencies

Add via `cargo add`:

```bash
cargo add tonic prost
cargo add --build tonic-build
```
