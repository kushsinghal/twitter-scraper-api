# Use slim Node base for smaller image size
FROM node:20-slim

# Install required dependencies
RUN apt-get update \
  && apt-get install -y wget tar ca-certificates fonts-liberation libappindicator3-1 \
    libasound2 libatk-bridge2.0-0 libatk1.0-0 libcups2 libdbus-1-3 \
    libgdk-pixbuf2.0-0 libnspr4 libnss3 libx11-xcb1 libxcomposite1 \
    libxdamage1 libxrandr2 xdg-utils unzip --no-install-recommends \
  && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy dependency files first
COPY package*.json ./

# Install dependencies
RUN npm install

# Download and extract Sparticuz Chromium
RUN mkdir -p node_modules/@sparticuz/chromium-min/bin \
  && wget -O /tmp/chromium.tar \
     https://github.com/Sparticuz/chromium/releases/download/v110.0.0/chromium-v110.0.0-pack.tar \
  && tar -xf /tmp/chromium.tar -C node_modules/@sparticuz/chromium-min/bin \
  && rm /tmp/chromium.tar

# Copy rest of the project
COPY . .

# Expose your app port
EXPOSE 3000

# Start the Node server
CMD ["npm", "start"]