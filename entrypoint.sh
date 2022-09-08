#/bin/sh


cd /src && mix ecto.create
cd /src && mix phx.server
