FROM elixir:1.9.4-slim

WORKDIR /src
COPY ./src/HelloWorld.exs /src/HelloWorld.exs
RUN chmod u+x /src/HelloWorld.exs
CMD ["elixir", "/src/HelloWorld.exs"]