# base
FROM node:12-alpine AS base

WORKDIR /app

# dependencies
COPY package*.json ./
RUN npm install && npm cache clean --force

# build
WORKDIR /app
COPY . .
RUN npm run build

# application
FROM node:12-alpine AS application

COPY --from=base /app/package*.json ./
RUN npm install --only=production
RUN npm install pm2 -g
COPY --from=base /app/dist ./dist

USER node
ENV PORT=8080
EXPOSE 8080

CMD ["pm2-runtime", "dist/main.js"]
