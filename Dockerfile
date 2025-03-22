FROM ruby:2.7-slim

# Install required system dependencies explicitly for ffi and sassc
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs openssl libssl-dev git libffi-dev

WORKDIR /app

RUN gem install bundler:2.2.33

COPY Gemfile .

# Clear any previous lockfiles to avoid version conflicts
RUN rm -f Gemfile.lock && bundle install

COPY . .

EXPOSE 4000

CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0", "--trace"]