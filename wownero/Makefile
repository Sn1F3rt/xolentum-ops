.PHONY: format help

# Help system from https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

up: ## Build and run the required containers by fetching binaries
	docker-compose -f docker-compose.yaml up -d

build: ## Build the required containers by fetching binaries
	docker-compose -f docker-compose.yaml build --no-cache

down: ## Stop the containers
	docker-compose -f docker-compose.yaml down

logs: ## Get logs from the containers
	docker-compose -f docker-compose.yaml logs -f
