FROM node:20-slim

# Install dependencies for Chromium and Puppeteer
RUN apt-get update \
    && apt-get install -y wget unzip ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy package files first
COPY package*.json ./

# Install node dependencies
RUN npm install

# Download and extract Sparticuz Chromium binary to the expected folder
RUN mkdir -p ./node_modules/@sparticuz/chromium-min/bin \
    && wget -O /tmp/chrome.zip https://github.com/Sparticuz/chromium/releases/download/v110.0.0/chromium-v110.0.0-pack.tar \
    && tar -xf /tmp/chrome.zip -C ./node_modules/@sparticuz/chromium-min/bin \
    && rm /tmp/chrome.zip

# Copy rest of the project
COPY . .

# Expose port
EXPOSE 3000

# Start the app
CMD [ "npm", "start" ]