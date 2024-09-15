# Stage 1: Build the application
FROM node:18 AS builder
WORKDIR /app

# Copy package.json and package-lock.json to install dependencies
COPY package.json package-lock.json ./

# Install all dependencies (including dev dependencies)
RUN npm install

# Copy all source files and build the application
COPY . .
RUN npm run build

# Stage 2: Serve the application
FROM node:18-alpine AS runner
WORKDIR /app

# Copy the built files from the builder stage
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/package.json ./

# Install production dependencies only
RUN npm install --only=production

# Expose port 3000 for the application
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
