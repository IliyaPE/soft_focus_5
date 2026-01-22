# syntax=docker/dockerfile:1
FROM ruby:3.1.0

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    imagemagick \
    libmagickwand-dev \
    curl

# Set directory
WORKDIR /app

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy code
COPY . .

# Precompile assets
RUN RAILS_ENV=production SECRET_KEY_BASE_DUMMY=1 bundle exec rake assets:precompile

# Expose port
EXPOSE 3000

# Start server
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
