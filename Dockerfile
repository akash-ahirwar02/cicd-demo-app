# Base image
FROM node:18-alpine

# Working directory container ke andar
WORKDIR /app

# Dependencies pehle copy karo (caching ke liye)
COPY package*.json ./
RUN npm install --only=production

# Baaki code copy karo
COPY . .

# Port expose karo
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', (r) => process.exit(r.statusCode === 200 ? 0 : 1))"

# App start karo
CMD ["node", "server.js"]
