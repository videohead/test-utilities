FROM python:3.12-slim AS base

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3-pip \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN pip3 install --no-cache-dir \
    pytest \
    playwright

# Set PLAYWRIGHT_BROWSERS_PATH to persist browser installs across containers
ENV PLAYWRIGHT_BROWSERS_PATH=/playwright-browsers

# Install playwright browsers (will persist in volume)
RUN playwright install --with-deps

# Install Node.js and pnpm for npx/playwright test
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && corepack enable \
    && corepack prepare pnpm@10.32.1 --activate

ENV PATH=/usr/local/bin:$PATH=/pnpm:$PATH
WORKDIR /opt

CMD ["bash"]