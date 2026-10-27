FROM node:24.21.0-slim AS dependencies
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --no-audit --no-fund
COPY . .

FROM dependencies AS test
RUN npm test

FROM dependencies AS build
RUN npm run build

FROM nginxinc/nginx-unprivileged:1.30.4-alpine AS runtime
COPY --from=build /app/index.html /usr/share/nginx/html/index.html
COPY --from=build /app/dist /usr/share/nginx/html/dist
COPY --from=build /app/css /usr/share/nginx/html/css
COPY --from=build /app/cv.json /app/config.json /app/icon.png /usr/share/nginx/html/
EXPOSE 8080
HEALTHCHECK --interval=10s --timeout=3s --start-period=5s --retries=5 \
  CMD wget -q -O /dev/null http://127.0.0.1:8080/ || exit 1
