FROM ubuntu:22.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# 1. Initial update and install of base dependencies + kitware repo requirements
RUN apt-get update && apt-get install -y \
    ca-certificates \
    gpg \
    wget \
    build-essential \
    pkg-config \
    mesa-utils \
    libx11-dev \
    libxrandr-dev \
    libxi-dev \
    libxcursor-dev \
    libxinerama-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libwayland-dev \
    libxkbcommon-dev \
    libasound2-dev \
    libpulse-dev \
    && rm -rf /var/lib/apt/lists/*

# 2. Add the Kitware repository for a modern CMake version (3.25+)
# We remove the old cmake provided by the base image first to avoid conflicts
RUN apt-get update && apt-get remove -y cmake && \
    wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor -o /usr/share/keyrings/kitware-archive-keyring.gpg && \
    echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ jammy main' | tee /etc/apt/sources.list.d/kitware.list >/dev/null && \
    apt-get update && apt-get install -y cmake && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /workspace