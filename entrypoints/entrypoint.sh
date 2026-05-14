#!/bin/sh

set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

# run the rails default server at port 3000
bundle exec rails s -b 0.0.0.0 -p 3000
