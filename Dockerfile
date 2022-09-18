FROM elixir:1.14-alpine

RUN mkdir -p /src && \
  apk add inotify-tools
COPY ./src/hello_pheonix/ /src/
WORKDIR /src
RUN mix local.hex --force && \
  mix archive.install hex phx_new --force && \
  mix deps.get && \
  mix local.rebar --force


ENV ELIXER_PORT=4000

COPY entrypoint.sh /root/entrypoint.sh
CMD ["/bin/sh", "/root/entrypoint.sh"]
# CMD ["mix", "run","--no-halt"]

EXPOSE 4000