FROM node:20-slim

# Install required Linux packages for Chromium to run
RUN apt-get update && apt-get install -y \
  wget \
  curl \
  tar \
  ca-certificates \
  fonts-liberation \
  libappindicator3-1 \
  libasound2 \
  libatk-bridge2.0-0 \
  libatk1.0-0 \
  libcups2 \
  libdbus-1-3 \
  libgdk-pixbuf2.0-0 \
  libnspr4 \
  libnss3 \
  libx11-xcb1 \
  libxcomposite1 \
  libxdamage1 \
  libxrandr2 \
  xdg-utils \
  unzip \
  --no-install-recommends && \
  rm -rf /var/lib/apt/lists/*

# Create working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# ✅ DOWNLOAD & EXTRACT CHROMIUM BINARY
RUN mkdir -p node_modules/@sparticuz/chromium-min/bin && \
    wget -O /tmp/chromium.tar https://github.com/Sparticuz/chromium/releases/download/v110.0.0/chromium-v110.0.0-pack.tar && \
    tar -xf /tmp/chromium.tar -C node_modules/@sparticuz/chromium-min/bin && \
    rm /tmp/chromium.tar

# Copy rest of app
COPY . .

# Start the server
EXPOSE 3000
CMD ["npm", "start"]