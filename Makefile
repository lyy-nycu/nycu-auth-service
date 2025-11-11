GREEN = \033[0;32m
BLUE = \033[0;34m
RED = \033[0;31m
NC = \033[0m
all: build

prepare:
	@echo -e ":: $(GREEN) Preparing environment...$(NC)"
	@echo -e ":: $(GREEN) Downloading go dependencies...$(NC)"
	@poetry install --with dev\
		&& echo -e "==> $(BLUE)Successfully installed dependencies$(NC)" \
		|| (echo -e "==> $(RED)Failed to install dependencies$(NC)" && exit 1)

run:
	@echo -e ":: $(GREEN)Starting backend...$(NC)"
	@echo -e ":: $(GREEN)Starting FastAPI server (dev mode)...$(NC)"
	@poetry run uvicorn main:app --reload --host 0.0.0.0 --port 8000

build:
	@echo -e ":: $(GREEN)Building production Docker image...$(NC)"
	@docker build -t nycu-auth-service:latest . \
		&& echo -e "==> $(BLUE)Successfully built Docker image (nycu-auth-service:latest)$(NC)" \
		|| (echo -e "==> $(RED)Docker build failed$(NC)" && exit 1)

lint:
	@echo -e ":: $(GREEN)Running Linter & Formatter Check (Ruff)...$(NC)"
	@poetry run ruff check . && poetry run ruff format --check . \
		|| (echo -e "==> $(RED)Linting/Formatting checks failed$(NC)" && exit 1)
	@echo -e ":: $(GREEN)Running Type Checker (Mypy)...$(NC)"
	@poetry run mypy . --ignore-missing-imports \
		|| (echo -e "==> $(RED)Type checking failed$(NC)" && exit 1)
	@echo -e "==> $(BLUE)All checks passed$(NC)"

test:
	@echo -e ":: $(GREEN)Running tests with Pytest...$(NC)"
	@poetry run pytest \
		&& echo -e "==> $(BLUE)All tests passed$(NC)" \
		|| (echo -e "==> $(RED)Tests failed$(NC)" && exit 1)