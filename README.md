# build-push-ecr

This github action builds a container that will run a node app (via `npm start`). The base image (gasbuddy/node-app) has
some opinions about ports and such, so if you're not at GasBuddy and you're using this step, it's probably as inspiration
and not directly.