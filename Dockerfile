FROM ruby

# Specify app directory on container
ENV APP_HOME /app

# Create app directory on container
RUN mkdir $APP_HOME

# Set working directory on container
WORKDIR $APP_HOME

# Install bundled gems to shared volume
ENV BUNDLE_PATH /bundled_gems

# Share project root as app directory on container
ADD . $APP_HOME

# For publishing docs using SSH
ENV USER jamesmead
ENV SSH_AUTH_SOCK /ssh/auth/sock

RUN git config --global user.email 'james@floehopper.org'
RUN git config --global user.name 'James Mead'
RUN git config --global push.default simple
