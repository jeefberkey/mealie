#!/bin/sh

# Get Reload Arg `run.sh reload` for dev server
ARG1=${1:-production}

# Set Script Directory - Used for running the script from a different directory.
# DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )" 

# # Initialize Database Prerun
poetry run python /app/mealie/db/init_db.py
poetry run python /app/mealie/services/image/minify.py

# Migrations
# TODO
    # Migrations
    # Set Port from ENV Variable

if [[ "$ARG1" = "reload" ]]
then
    echo "Hot Reload!"

    # Start API
    uvicorn mealie.app:app --host 0.0.0.0 --port 9000 --reload
else
    echo "Production"
    # Web Server
    caddy start --config ./Caddyfile

    # Start API
    uvicorn mealie.app:app --host 0.0.0.0 --port 9000
fi

