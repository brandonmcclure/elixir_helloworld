FROM elixir:1.14

RUN mkdir -p /src
COPY ./src/hello_pheonix/ /src/
WORKDIR /src
RUN mix local.hex --force && \
  mix archive.install hex phx_new --force && \
  mix deps.get && \
  mix local.rebar --force
COPY entrypoint.sh /root/entrypoint.sh
CMD ["/bin/bash", "/root/entrypoint.sh"]
# CMD ["mix", "run","--no-halt"]

EXPOSE 4000