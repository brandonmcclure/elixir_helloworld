FROM elixir:1.14-slim

RUN mkdir -p /src/webserver
COPY ./src/webserver/ /src/
WORKDIR /src
RUN mix local.hex --force && \
  mix deps.get && \
  mix local.rebar --force
CMD ["mix", "run","--no-halt"]