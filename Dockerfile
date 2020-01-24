# gets the docker image of ruby 2.6 and lets us build on top of that
FROM ruby:2.6.0-slim

RUN apt-get update -qq && apt-get -y install curl
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev libsqlite3-dev nodejs
RUN npm install -g yarn

# create a folder /myapp in the docker container and go into that folder
RUN mkdir /myapp
WORKDIR /myapp

# Copy the Gemfile and Gemfile.lock from app root directory into the /myapp/ folder in the docker container
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

# Run bundle install to install gems inside the gemfile
RUN gem install bundler && bundle install

COPY package.json package.json
RUN yarn install --check-files

ENV RAILS_ENV='production'

# Copy the whole app
COPY . /myapp
