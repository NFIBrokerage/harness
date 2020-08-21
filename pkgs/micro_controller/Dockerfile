# The version of Alpine to use for the final image
# This should match the version of Alpine that the `elixir:1.7.4-alpine` image uses
ARG ALPINE_VERSION=3.9
ARG ELIXIR_VERSION

FROM elixir:${ELIXIR_VERSION}-alpine AS builder

ARG CUATRO_HEX_KEY
ARG CUATROBUILD_SSH_KEY
ARG REPOSITORY

# Set this to true if this release _is_ a Phoenix app
ARG APP_HAS_ASSETS=true
ARG PHOENIX_SUBDIR=.

# The environment to build with
ARG MIX_ENV=prod

ENV APP_HAS_ASSETS=${APP_HAS_ASSETS} \
    REPOSITORY=${REPOSITORY} \
    CUATRO_HEX_KEY=${CUATRO_HEX_KEY} \
    CUATROBUILD_SSH_KEY=${CUATROBUILD_SSH_KEY} \
    MIX_ENV=${MIX_ENV}

# By convention, /opt is typically used for applications
WORKDIR /opt/app

# This step installs all the build tools we'll need
RUN apk update && \
  apk upgrade --no-cache && \
  apk add --no-cache \
    nodejs \
    yarn \
    git \
    openssh-client \
    build-base && \
  mix local.rebar --force && \
  mix local.hex --force

RUN mkdir -p ~/.ssh/ && \
    echo "${CUATROBUILD_SSH_KEY}" > ~/.ssh/id_rsa && \
    chmod -R 600 ~/.ssh/ && \
    ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts

# This copies our app source code into the build container
COPY . .

RUN mix hex.organization auth cuatro --key=$CUATRO_HEX_KEY

RUN mix do deps.get, deps.compile, compile

# This step builds assets for the Phoenix app (if there is one)
# If you aren't building a Phoenix app, pass `--build-arg APP_HAS_ASSETS=true`
# This is mostly here for demonstration purposes
RUN if [ "$APP_HAS_ASSETS" = "true" ]; then \
  cd ${PHOENIX_SUBDIR}/assets && \
  yarn install && \
  yarn deploy && \
  cd - && \
  mix phx.digest; \
fi

RUN \
  mkdir -p /opt/built && \
  mix release --env=prod && \
  cp _build/${MIX_ENV}/rel/${REPOSITORY}/releases/$(git describe --tags --long --always)/${REPOSITORY}.tar.gz /opt/built && \
  cd /opt/built && \
  tar -xzf ${REPOSITORY}.tar.gz && \
  rm ${REPOSITORY}.tar.gz

# From this line onwards, we're in a new container image:
#
# - secrets like the SSH key are forgotten from the prior image
# - this is the runtime for the prod tarball

FROM alpine:${ALPINE_VERSION}

ARG REPOSITORY

RUN apk update && \
    apk add --no-cache \
      bash \
      openssl-dev \
      openssl

ENV REPLACE_OS_VARS=true \
    REPOSITORY=${REPOSITORY}

WORKDIR /opt/app

COPY --from=builder /opt/built .

EXPOSE 4000/tcp

CMD trap 'exit' INT; /opt/app/bin/${REPOSITORY} foreground

HEALTHCHECK --interval=4m --timeout=5s \
  CMD /opt/app/bin/${REPOSITORY} ping
