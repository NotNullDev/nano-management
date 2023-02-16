FROM node:16-bullseye as build-frontend

WORKDIR /app

COPY ./frontend/package.json ./frontend/yarn.lock ./

RUN yarn install

COPY ./frontend ./

RUN yarn build

RUN yarn next export

FROM golang:1.19-buster AS build-backend

WORKDIR /app

COPY backend/go.mod ./
COPY backend/go.sum ./
RUN go mod download
RUN go mod tidy

COPY backend ./

RUN go build -o app .

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