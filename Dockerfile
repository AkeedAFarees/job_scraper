FROM ruby:3.1.0
# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs nano


# install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y yarn
RUN yarn install


RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY . /usr/src/app

RUN bundle install
# RUN EDITOR=nano rails credentials:edit
# RUN RAILS_ENV=production bundle exec rake assets:precompile
# RUN bundle exec rails db:migrate


COPY bootstart.sh /
RUN chmod +x /bootstart.sh
#ENTRYPOINT ["/bootstart.sh"]

EXPOSE 3001
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3001", "-e", "production"]
