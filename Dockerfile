# syntax=docker/dockerfile:1

FROM node:16-bullseye as build-frontend

WORKDIR /app

COPY ./frontend/package.json ./frontend/yarn.lock ./

RUN ls -lah

RUN yarn cache list

RUN \
    --mount=type=cache,target=/root/.cache/yarn \
    yarn cache list && yarn --cache-folder /root/.cache/yarn install

COPY ./frontend ./

RUN ls -lah

RUN yarn build && ls

RUN yarn next export

FROM golang:1.19-buster AS build-backend

WORKDIR /app

COPY backend ./

RUN \
    --mount=type=cache,target=/root/.cache/go-build \
    GOCACHE=/root/.cache/go-build \
    go mod tidy


RUN go build -o app -buildvcs=false .

# TODO: Use a smaller image
FROM ubuntu:22.04

WORKDIR /app
COPY --from=build-backend /app/app .
COPY --from=build-backend /app/pb_migrations ./pb_migrations

COPY --from=build-frontend /app/out ./pb_public

RUN ls -la
RUN ls -la pb_public

EXPOSE 8090

CMD [ "./app", "serve", "--http=0.0.0.0:8090" ]