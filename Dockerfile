# Stage 1: Build the Go application
FROM golang:1.17 AS build

# Install any dependencies required for your Go application
WORKDIR /app
COPY go.mod .
COPY go.sum .
RUN go mod download

# Copy the rest of the application source code
COPY . .

# Build the Go application
RUN go build -o app .

# Stage 2: Final image
FROM debian:bullseye-slim

# Install ffmpeg and Python
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ffmpeg \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Install yt-dlp using pip
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3-pip \
    && pip3 install --no-cache-dir yt-dlp \
    && apt-get purge -y python3-pip \
    && apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Copy the built Go application from the previous stage
COPY --from=build /app/app /usr/local/bin/app

# Set the working directory
WORKDIR /root

# Run the application
CMD ["app"]
