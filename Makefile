.PHONY: setup lint test up down

setup:
	python3.11 -m venv .venv && . .venv/bin/activate && pip install -r requirements-dev.txt && pre-commit install

lint:
	ruff check . && ruff format --check .

test:
	pytest -q

up:
	@echo "docker compose stack will be added in Stage 2"

down:
	@echo "docker compose stack will be added in Stage 2"
