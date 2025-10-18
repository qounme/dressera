.PHONY: help build run bundle rails setup biome

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | grep -v '^help:' | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s %s\n", $$1, $$2}'
	@grep -E '^help:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s %s\n", $$1, $$2}'
	@echo ''
	@echo 'Note: When passing options starting with "-", use "--" separator.'
	@echo '      Example: make -- rails -v'

# Container commands
build: ## Build the Docker image for development
	docker build -f Dockerfile.dev -t dressera-dev .

run: ## Run the development container
	docker run -it --rm -p 3000:3000 --mount type=bind,source=$(CURDIR),target=/rails --name dressera-dev dressera-dev

bundle: ## Run bundle command in container (usage: make bundle install)
	docker run --rm --mount type=bind,source=$(CURDIR),target=/rails dressera-dev bundle $(filter-out $@,$(MAKECMDGOALS))
	@:

rails: ## Run rails command in container (usage: make rails db:migrate)
	docker run --rm --mount type=bind,source=$(CURDIR),target=/rails dressera-dev bin/rails $(filter-out $@,$(MAKECMDGOALS))
	@:

# Host commands
setup: ## Setup host environment for editor support (creates separate lockfile in .bundle/)
	bundle config set --local lockfile .bundle/Gemfile_host.lock
	cp Gemfile.lock .bundle/Gemfile_host.lock
	bundle install

biome: ## Format and lint JS/CSS files with Biome
	npx @biomejs/biome check --write .

# Dummy target to prevent make from interpreting subcommands as targets
# This allows commands like "make rails db:migrate" to work correctly
%:
	@:
