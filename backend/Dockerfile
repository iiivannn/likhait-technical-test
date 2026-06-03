# syntax = docker/dockerfile:1

# Use Ruby 3.3.7
ARG RUBY_VERSION=3.3.7
FROM ruby:$RUBY_VERSION-slim

# Rails app lives here
WORKDIR /rails

# Install base packages including dos2unix
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential ca-certificates default-mysql-client default-libmysqlclient-dev git libyaml-dev dos2unix && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Configure Git to use LF line endings
RUN git config --global core.eol lf && git config --global core.autocrlf false

# Install application gems
COPY Gemfile Gemfile.lock ./

# Configure bundler and install gems with retry logic
RUN bundle config set --local deployment 'false' && \
    bundle config set --local path '/usr/local/bundle' && \
    bundle install --jobs 4 --retry 3

# Copy application code
COPY . .

# Convert all bin scripts from CRLF to LF
RUN find /rails/bin -type f -exec dos2unix {} \; && chmod +x /rails/bin/*

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile --gemfile app/ lib/

# Copy entrypoint script and convert CRLF to LF using dos2unix
COPY bin/docker-entrypoint /rails/bin/docker-entrypoint
RUN dos2unix /rails/bin/docker-entrypoint && chmod +x /rails/bin/docker-entrypoint

# Entrypoint prepares the database
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default
EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
