# websocket-python-example

[![Build](https://github.com/jecklgamis/websocket-python-example/actions/workflows/build.yaml/badge.svg)](https://github.com/jecklgamis/websocket-python-example/actions/workflows/build.yaml)

A production-ready WebSocket client/server app using FastAPI.

Docker Run:
```bash
docker run --rm --name websocket-python-example -p 8080:8080 -it jecklgamis/websocket-python-example:main
```

## Tech Stack

- **FastAPI** - async web framework with WebSocket support
- **websockets** - WebSocket client library
- **Pydantic v2** - validation and settings management
- **Docker** - containerized deployment (Python 3.12-slim)
- **Helm** - Kubernetes deployment chart
- **Ruff** - linting and formatting
- **pytest** - testing with async support

## Project Structure

```
├── app/
│   ├── __init__.py        # Global logging init (INFO level)
│   ├── main.py            # FastAPI application entry point
│   ├── config.py          # Environment-specific settings (dev/test/prod)
│   └── routers/           # API route handlers
│       └── websocket.py   # WebSocket /ws endpoint
├── tests/                 # Test suite
├── deployment/
│   └── k8s/helm/          # Helm chart and deploy Makefile
├── websocket_client.py    # WebSocket client
├── run-server.sh          # Start the server
├── run-client.sh          # Start the client
├── Dockerfile
├── Makefile
└── pyproject.toml
```

## Getting Started

### Prerequisites

- Python 3.12+
- [uv](https://github.com/astral-sh/uv) (recommended)
- [Docker](https://www.docker.com/) (for containerized deployment)

```bash
# Clone the repository
git clone git@github.com:jecklgamis/websocket-python-example.git && cd websocket-python-example
```
```bash
# Install dependencies
make install-deps
```

```bash
# Start the dev server (uses .env.dev by default)
make run-dev
```

The server will be available at `http://localhost:8080`. This will reload on file changes.

### Running the Client

```bash
./run-client.sh
```

Type a message and press Enter to send. The server echoes it back. Press Ctrl+C to quit.

### Using Docker

```bash
# Build and run
make up

# Or separately
make docker-image
make docker-run

```

## Endpoints

| Method      | Endpoint          | Description                            |
|-------------|-------------------|----------------------------------------|
| `GET`       | `/`               | Welcome message                        |
| `GET`       | `/health`         | Health check                           |
| `GET`       | `/probe/live`     | Liveness probe                         |
| `GET`       | `/probe/ready`    | Readiness probe                        |
| `GET`       | `/probe/startup`  | Startup probe                          |
| `GET`       | `/status/`        | System status (Basic Auth)             |
| `GET`       | `/build-info`     | Build info (commit, branch, timestamp) |
| `WebSocket` | `/ws`             | Echo WebSocket endpoint                |

Interactive API docs are available at `/docs` (Swagger UI) and `/redoc`.

## Development

```bash
# Run tests
make test

# Lint and type-check
make lint

# Auto-fix and format
make format

# Dependency vulnerability scan
make audit

# Full pipeline (clean, install, format, lint, test, docker-image)
make all
```

## Helm Chart

A Helm chart is provided in `deployment/k8s/helm/` for Kubernetes deployment.

```bash
cd deployment/k8s/helm

# Dry run to verify
make dry-run

# Install
make install

# Upgrade after changes
make upgrade

# Rollback
make rollback

# Uninstall
make uninstall
```

Default configuration in `chart/values.yaml`:

| Key                   | Default                               |
|-----------------------|---------------------------------------|
| `image.repository`    | `jecklgamis/websocket-python-example` |
| `image.tag`           | `main`                                |
| `service.type`        | `ClusterIP`                           |
| `service.port`        | `80`                                  |
| `ingress.enabled`     | `true`                                |
| `autoscaling.enabled` | `false`                               |
| `replicaCount`        | `1`                                   |

## Configuration

Settings are managed via environment variables and loaded from env-specific files. Set `APP_ENV` to select the environment:

| Environment | Env File    | Debug   | Description                    |
|-------------|-------------|---------|--------------------------------|
| `dev`       | `.env.dev`  | `true`  | Local development (default)    |
| `test`      | `.env.test` | `true`  | Test suite (set automatically) |
| `prod`      | `.env.prod` | `false` | Production                     |

```bash
# Run with a specific environment
APP_ENV=prod make run
```

### Environment Variables

| Variable              | Default                    | Description                         |
|-----------------------|----------------------------|-------------------------------------|
| `APP_ENV`             | `dev`                      | Environment (`dev`, `test`, `prod`) |
| `APP_NAME`            | `websocket-python-example` | Application name                    |
| `DEBUG`               | `false`                    | Enable debug mode                   |
| `BASIC_AUTH_USERNAME` | `admin`                    | Basic Auth username for /status     |
| `BASIC_AUTH_PASSWORD` | `password`                 | Basic Auth password for /status     |

## License

Apache 2.0 - see [LICENSE](LICENSE)
