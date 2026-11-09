# Test Utilities Docker Environment

This Docker image provides shared Python and Node.js test utilities accessible
to all projects under /opt.

## What's Included

- **Python 3.12** with pytest for testing
- **Playwright** for browser automation
- **Node.js** with pnpm package manager (from base image)
- **Playwright browsers** installed for test automation
- **Persistent browser storage** via PLAYWRIGHT_BROWSERS_PATH environment variable

## Usage

### Run Container

```bash
# Using docker run with persistent browser storage
docker run --rm -v playwright-browsers:/playwright-browsers test-utilities pytest

# Using docker-compose
docker-compose up test-utilities
```

### Access from Other Projects

Projects can use this image as a base or runtime. Mount the project directory
as read-only and use the test-utilities image to run tests:

```yaml
# Example docker-compose.yml for any project under /opt
services:
  test-utilities:
    image: test-utilities:latest
    volumes:
      - ./:/opt/project:ro
    working_dir: /opt/project
    environment:
      - PLAYWRIGHT_BROWSERS_PATH=/playwright-browsers
```

### Access from Other /opt Directories

The test-utilities image can be used from any project directory under /opt:

```bash
# From /opt/morphazoid
docker run --rm -v /opt/morphazoid:/opt/morphazoid:ro -w /opt/morphazoid test-utilities pytest

# From /opt/videobrain
docker run --rm -v /opt/videobrain:/opt/videobrain:ro -w /opt/videobrain test-utilities npx playwright test

# From /opt/chatbot
docker run --rm -v /opt/chatbot:/opt/chatbot:ro -w /opt/chatbot test-utilities pytest
```

### Available Commands

Inside the container:
- `python3 -c "..."` - Run Python one-liners
- `pytest` - Run pytest tests
- `python3 -m pytest` - Run pytest with more options
- `npx playwright test` - Run Playwright tests
- `playwright codegen` - Launch Playwright codegen
- `pnpm install` - Install Node.js dependencies
- `pnpm exec tsx script.ts` - Run TypeScript scripts

### Extending

To add more tools, extend the Dockerfile or use docker-compose to mount
additional volumes. The PLAYWRIGHT_BROWSERS_PATH environment variable will
persist browser installs across container restarts when mounted as a volume.

### Notes

- The image is based on `python:3.12-slim` for a small footprint
- Playwright browsers are persisted via PLAYWRIGHT_BROWSERS_PATH volume
- Node.js pnpm is available from the base `node:22-bookworm` image
- Volumes can be mounted read-write for test result output, or read-only for project code
- To persist browsers across projects, create a named volume: `docker volume create playwright-browsers`