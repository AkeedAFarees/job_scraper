#!/bin/sh
cd /usr/src/app

RAILS_ENV=production bundle exec rake assets:precompile
bundle exec rails db:migrate >> log/migration-logs.$(date +%Y-%m-%d_%H:%M).log 2>&1
