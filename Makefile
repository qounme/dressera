.PHONY: help build run

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | grep -v '^help:' | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s %s\n", $$1, $$2}'
	@grep -E '^help:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s %s\n", $$1, $$2}'

build: ## Build the Docker image for development
	docker build -f Dockerfile.dev -t dressera-dev .

run: ## Run the development container
	docker run -it --rm -p 3000:3000 --mount type=bind,source=$(CURDIR),target=/rails --name dressera-dev dressera-dev
