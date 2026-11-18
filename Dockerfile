# ============================================
# MULTI-STAGE SECURE DOCKERFILE
# Healthcare DevSecOps - HIPAA Compliant
# ============================================

# Stage 1: Build Dependencies
FROM node:20-alpine AS builder

# Security: Don't run as root during build
RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup

WORKDIR /app

# Copy package files first (layer caching optimization)
COPY package*.json ./

# Install production dependencies only
RUN npm ci --only=production --ignore-scripts && \
    npm cache clean --force

# Stage 2: Production Image
FROM node:20-alpine AS production

# Security labels
LABEL maintainer="DevSecOps Team"
LABEL description="Healthcare API - HIPAA Compliant"
LABEL version="1.0.0"
LABEL security.compliance="HIPAA"

# Security: Install security updates
RUN apk update && \
    apk upgrade --no-cache && \
    apk add --no-cache dumb-init && \
    rm -rf /var/cache/apk/*

# Security: Create non-root user
RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup

WORKDIR /app

# Copy built dependencies from builder stage
COPY --from=builder --chown=appuser:appgroup /app/node_modules ./node_modules

# Copy application code
COPY --chown=appuser:appgroup . .

# Create logs directory
RUN mkdir -p logs && chown appuser:appgroup logs

# Security: Remove unnecessary files
RUN rm -rf .git .github tests .eslintrc.json .env.example

# Security: Set restrictive file permissions
RUN chmod -R 550 /app && \
    chmod -R 770 /app/logs

# Security: Set environment variables
ENV NODE_ENV=production
ENV PORT=3000

# Security: Expose only the necessary port
EXPOSE 3000

# Security: Run as non-root user
USER appuser

# Security: Use dumb-init to handle signals properly
ENTRYPOINT ["dumb-init", "--"]

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/api/health', (r) => { process.exit(r.statusCode === 200 ? 0 : 1); }).on('error', () => process.exit(1));"

CMD ["node", "src/server.js"]
