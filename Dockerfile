# Leverage the official Ruby image from Docker Hub
# https://hub.docker.com/_/ruby
FROM ruby:2.6

# Install recent versions of nodejs (10.x) and yarn pkg manager
# Needed to properly pre-compile Rails assets
RUN (curl -sL https://deb.nodesource.com/setup_10.x | bash -) && apt-get install -y nodejs 

RUN (curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -) && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn

# Install MySQL client (needed for the connection to Google CloudSQL instance)
RUN apt-get install -y mysql-client

# Install production dependencies (Gems installation in
# local vendor directory)
WORKDIR /usr/src/app
COPY Gemfile Gemfile.lock ./
ENV BUNDLE_FROZEN=true
RUN bundle install

# Copy application code to the container image.
COPY . .

# Pre-compile Rails assets (master key needed)
RUN RAILS_ENV=production bundle exec rake assets:precompile

# Set Google App Credentials environment variable with Service Account
ENV GOOGLE_APPLICATION_CREDENTIALS=/usr/src/app/config/photo_album_runner.key

# Setup Rails DB password passed on docker command line (see Cloud Build file)
ARG DB_PWD
ENV DATABASE_PASSWORD=${DB_PWD}

# For now we don't have a Nginx/Apache frontend so tell 
# the Puma HTTP server to serve static content
# (e.g. CSS and Javascript files)
ENV RAILS_SERVE_STATIC_FILES=true

# Designate the initial sript to run on container startup
RUN chmod +x /usr/src/app/entrypoint.sh
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]
