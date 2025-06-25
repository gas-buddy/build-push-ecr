ARG NODE_IMAGE_TAG=14-production

FROM ghcr.io/gas-buddy/docker-gasbuddy-nodeapp:${NODE_IMAGE_TAG}

ARG NODE_ENV_ARG=production
ARG APK_PACKAGES
ARG NPM_TOKEN

WORKDIR /pipeline/source

COPY . .

ENV NODE_ENV=$NODE_ENV_ARG

RUN apk add --no-cache --virtual .npm-deps build-base python3 openssl make gcc g++ ${APK_PACKAGES} && \
  echo "//registry.npmjs.org/:_authToken=$NPM_TOKEN" > ~/.npmrc && \
  rm -rf node_modules/.bin && \
  npm i -g node-pre-gyp prebuild-install && \
  npm rebuild && \
  npm prune --production && \
  rm -rf ~/.npmrc src tests coverage .nyc_output /pipeline/cache config/development.json .git && \
  apk del .npm-deps && \
  npm uninstall -g node-pre-gyp prebuild-install
