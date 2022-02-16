FROM ruby:3.1.0-alpine
# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

############################
# rails postgres dependencies
#---------------------------
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main 9.5" > /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update
# libpq-dev is required for the pg gem
RUN apt-get install -y libpq-dev postgresql-client-9.5



RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY . /usr/src/app

RUN bundle install
RUN bundle exec rails db:migrate


EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
