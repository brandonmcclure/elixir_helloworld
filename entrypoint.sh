#!/bin/sh

# Create the database as configured
mix ecto.create

mix phx.server

(
	mix ecto.create
	rc=$?
	if [[ $rc != 0 ]]; then echo "init.sh failed with code $rc" && kill "$(ps aux | pgrep 'mix' | awk '{print $2}')"; fi
) \
	&
mix phx.server
