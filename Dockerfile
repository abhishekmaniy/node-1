# Multi-stage build for Node + TypeScript project
FROM node:20-alpine AS builder
WORKDIR /app

# Copy package files and tsconfig first to take advantage of Docker layer caching
COPY package.json package-lock.json* tsconfig.json ./

# Install all dependencies (including devDependencies) so we can build
RUN npm install

# Copy source and build
COPY src ./src
RUN npm run build

### Runtime image
FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production

# Copy compiled output and production deps
COPY --from=builder /app/dist ./dist
COPY package.json ./

# Install only production dependencies
RUN npm install --production

EXPOSE 3000
CMD ["node", "dist/index.js"]
