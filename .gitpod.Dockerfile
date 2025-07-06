FROM ubuntu:22.04

# Install required packages
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    git \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Install PocketBase binary
RUN curl -L -o pb.zip https://github.com/pocketbase/pocketbase/releases/download/v0.24.2/pocketbase_0.24.2_linux_amd64.zip && \
    unzip pb.zip -d /usr/local/bin/ && \
    rm pb.zip && \
    chmod +x /usr/local/bin/pb

# Install pnpm globally (for Svelte frontend)
RUN npm install -g pnpm

# Set working directory
WORKDIR /workspace

# Create backend directory and copy pb binary
RUN mkdir -p /workspace/backend && \
    cp /usr/local/bin/pb /workspace/backend/pb
