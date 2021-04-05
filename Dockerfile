FROM rust as builder

WORKDIR /usr/src/sccache

RUN apt-get update \
 && apt-get install -y libssl-dev --no-install-recommends

RUN cargo install --features="dist-client dist-server" sccache --git https://github.com/mozilla/sccache.git --rev 6b6d2f7d2dceefeb4f583712aa4c221db62be0bd

FROM debian:bullseye-slim

RUN apt-get update \
 && apt-get install -y libssl1.1 --no-install-recommends \
 && apt-get install bubblewrap

COPY --from=builder /usr/local/cargo/bin/ /usr/local/bin/

STOPSIGNAL SIGINT

ENTRYPOINT ["/usr/local/bin/sccache-dist"]
