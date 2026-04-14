GIT_COMMIT := $(shell git rev-parse --short HEAD)
GIT_BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
DOCKER_IMAGE := websocket-python-example:$(GIT_BRANCH)
CONTAINER_NAME := websocket-python-example

.PHONY: all install-deps format lint audit test run run-dev \
        build-info docker-image docker-run docker-stop up clean

# === Build pipeline ===
all: clean install-deps format lint test docker-image

install-deps:
	uv pip install -e ".[dev]"

format:
	ruff check --fix .
	ruff format .

lint:
	ruff check .
	mypy app/

audit:
	pip-audit

test:
	pytest -v

# === Server ===
run:
	uvicorn app.main:app --host 0.0.0.0 --port 8080

run-dev:
	uvicorn app.main:app --reload --port 8080

# === Docker ===
build-info:
	@echo '{"app":"websocket-python-example","version":"0.1.0","git_commit":"$(GIT_COMMIT)","git_branch":"$(GIT_BRANCH)","build_timestamp":"$(shell date -u +%Y-%m-%dT%H:%M:%SZ)"}' > build-info.json

docker-image: build-info
	docker build -t $(DOCKER_IMAGE) .

docker-run:
	-docker rm -f $(CONTAINER_NAME)
	docker run --rm --name $(CONTAINER_NAME) -p 8080:8080 -it $(DOCKER_IMAGE)

docker-stop:
	-docker rm -f $(CONTAINER_NAME)

up: docker-image docker-run

# === Cleanup ===
clean:
	rm -rf .mypy_cache .pytest_cache .ruff_cache
	rm -rf *.egg-info dist build build-info.json
	find . -type d -name __pycache__ -exec rm -rf {} +
