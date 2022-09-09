ARG TARGET_ELIXER_VERSION=:1.14-alpine
FROM elixir${TARGET_ELIXER_VERSION}

RUN mkdir -p /src && \
  apk add inotify-tools

COPY ./src/hello_pheonix/ /src/
WORKDIR /src
RUN mix local.hex --force && \
  mix archive.install hex phx_new --force && \
  mix deps.get && \
  mix local.rebar --force
COPY entrypoint.sh /root/entrypoint.sh
CMD ["/bin/sh", "/root/entrypoint.sh"]
# CMD ["mix", "run","--no-halt"]

EXPOSE 4000