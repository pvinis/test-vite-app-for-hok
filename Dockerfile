FROM node:current-alpine

WORKDIR /app

# Install system dependencies
# Add deploy user
RUN apk --no-cache --quiet add \
    dumb-init && \
    adduser -D -g '' deploy

# Copy files required for installation of application dependencies
COPY package.json yarn.lock ./

# If you use https://github.com/ds300/patch-package uncomment the following line
# COPY patches ./patches

# Install application dependencies
RUN yarn install --frozen-lockfile && yarn cache clean

# Copy application code
COPY . ./

# Build application
# Update file/directory permissions
RUN yarn build && \
    chown -R deploy:deploy ./

# Switch to less-privileged user
USER deploy

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["yarn", "dev"]
