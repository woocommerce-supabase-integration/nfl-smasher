# Dockerfile for PocketBase production deployment (Fly.io)
FROM alpine:3.18

WORKDIR /pb

# Install required packages
RUN apk add --no-cache curl unzip

# Download and install PocketBase
RUN curl -L -o pb.zip https://github.com/pocketbase/pocketbase/releases/download/v0.24.2/pocketbase_0.24.2_linux_amd64.zip \
    && unzip pb.zip \
    && rm pb.zip \
    && chmod +x ./pb

# Create data directory
RUN mkdir -p pb_data

# Expose port
EXPOSE 8090

# Run PocketBase
CMD ["./pb", "serve", "--http=0.0.0.0:8090", "--dir=pb_data"]
