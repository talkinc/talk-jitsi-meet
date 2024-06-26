#Stage 1
FROM node:17-alpine as builder
WORKDIR /app
COPY package.json .
COPY package-lock.json .
RUN npm i --save --force --legacy-peer-deps
COPY . .
RUN apk update && apk add --update make
RUN make

#Stage 2
FROM nginx:1.19.0
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY --from=builder /app/build .
COPY --from=builder /app .
ENTRYPOINT ["nginx", "-g", "daemon off;"]