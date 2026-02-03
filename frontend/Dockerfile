# syntax=docker/dockerfile:1

FROM node:20-alpine AS build
WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

FROM nginx:1.25-alpine

# Copy nginx config template for envsubst processing
# nginx:alpine image automatically processes templates in /etc/nginx/templates/
COPY nginx.railway.conf /etc/nginx/templates/default.conf.template

# Copy built frontend
COPY --from=build /app/dist /usr/share/nginx/html

# Set default values for environment variables (can be overridden at runtime)
ENV ACCOUNTS_SERVICE_URL=http://localhost:8001
ENV SPACES_SERVICE_URL=http://localhost:8002
ENV RESERVATIONS_SERVICE_URL=http://localhost:8003

# Specify which variables to substitute
ENV NGINX_ENVSUBST_OUTPUT_DIR=/etc/nginx/conf.d

EXPOSE 80

# nginx:alpine image handles envsubst automatically via docker-entrypoint.sh
