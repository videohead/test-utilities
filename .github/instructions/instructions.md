# Test Utilities Instructions

## Running Tests from Any /opt Project

Use the test-utilities Docker image to run pytest and Playwright tests from any
project directory under `/opt`:

```bash
# From /opt, run pytest in morphazoid project
docker run --rm --v /opt/morphazoid:/opt/morphazoid:ro -w /opt/morphazoid test-utilities pytest

# From /opt, run pytest in videobrain project
docker run --rm -v /opt/videobrain:/opt/videobrain:ro -w /opt/videobrain test-utilities pytest

# From /opt, run pytest in chatbot project
docker run --rm -v /opt/chatbot:/opt/chatbot:ro -w /opt/chatbot test-utilities pytest

# From /opt, run Playwright tests in videobrain project
docker run --rm -v /opt/videobrain:/opt/videobrain:ro -w /opt/videobrain test-utilities npx playwright test

# Run with verbose output
docker run --rm -v /opt/chatbot:/opt/chatbot:ro -w /opt/chatbot test-utilities python3 -m pytest -v
```

## Docker Compose Usage

Add test-utilities service to your project's docker-compose.yml:

```yaml
services:
  test-utilities:
    image: test-utilities:latest
    volumes:
      - ./:/opt/project:ro
    working_dir: /opt/project
    environment:
      - PLAYWRIGHT_BROWSERS_PATH=/playwright-browsers
```

Then run:
```bash
docker-compose run --rm test-utilities pytest
```

## Persistent Browser Storage

To avoid repeated Playwright browser downloads across projects and container restarts:

1. Create a named volume once:
   ```bash
   docker volume create playwright-browsers
   ```

2. Mount the volume when running test-utilities:
   ```bash
   docker run --rm -v playwright-browsers:/playwright-browsers test-utilities pytest
   ```

3. Or in docker-compose.yml:
   ```yaml
   services:
     test-utilities:
       image: test-utilities:latest
       volumes:
         - playwright-browsers:/playwright-browsers
   ```

The `PLAYWRIGHT_BROWSERS_PATH=/playwright-browsers` environment variable
ensures browser binaries persist across container restarts and can be shared
across all projects under /opt.

## Available Test Commands

Inside the test-utilities container:

| Command | Description |
|---------|-------------|
| `pytest` | Run pytest tests in current directory |
| `python3 -m pytest` | Run pytest with more options |
| `python3 -m pytest -v` | Verbose test output |
| `npx playwright test` | Run Playwright tests |
| `playwright codegen` | Launch Playwright codegen UI |
| `pnpm install` | Install Node.js dependencies |
| `pnpm exec tsx script.ts` | Run TypeScript scripts |
| `npx tsx script.ts` | Run TypeScript scripts directly |

## Image Build

To rebuild the test-utilities image after making changes:

```bash
cd /opt/test-utilities
docker build -t test-utilities .
```

## Extending the Image

To add more tools, edit the Dockerfile at `/opt/test-utilities/Dockerfile` and
rebuild. Common additions:

- Additional Python packages: `RUN pip3 install --no-cache-dir <package>`
- More Node.js tools: Add to the Node.js base layer
- System packages: `RUN apt-get update && apt-get install -y <package>`
- Custom test scripts or configurations