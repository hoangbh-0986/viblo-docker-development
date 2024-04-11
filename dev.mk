ifeq (,$(wildcard .env))
    $(shell cp .env.example .env)
endif

include .env
export $(shell sed 's/=.*//' .env)

ifeq (sh,$(firstword $(MAKECMDGOALS)))
    CONTAINER := $(firstword $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS)))
    $(eval $(CONTAINER):;@:)
endif

devup:
	USER=$$(id -u):$$(id -g) docker-compose up -d --remove-orphans

devinstall:
	@docker exec -it -u $$(id -u):$$(id -g) $(COMPOSE_PROJECT_NAME)_php_1 composer install
	@docker exec -it -u $$(id -u):$$(id -g) $(COMPOSE_PROJECT_NAME)_web_1 yarn
	@test -f $(PATH_PHP)/.env || (cp $(PATH_PHP)/.env.example $(PATH_PHP)/.env && docker exec -it $(COMPOSE_PROJECT_NAME)_php_1 php artisan key:generate)
	@test -f $(PATH_WEB)/.env || cp $(PATH_WEB)/.env.example $(PATH_WEB)/.env
	@docker exec -it $(COMPOSE_PROJECT_NAME)_php_1 sh -c "chown -R :www-data storage/* bootstrap/cache"
	@test -d .vscode || (mkdir .vscode && echo '{ "eslint.workingDirectories": [ "web" ] }' > .vscode/settings.json)

devrun:
	docker exec -it -u $$(id -u):$$(id -g) $(COMPOSE_PROJECT_NAME)_web_1 yarn dev

devmigrate:
	USER=$$(id -u):$$(id -g) docker exec -it -u $$(id -u):$$(id -g) $(COMPOSE_PROJECT_NAME)_php_1 php artisan migrate --seed

devfresh:
	USER=$$(id -u):$$(id -g) docker exec -it -u $$(id -u):$$(id -g) $(COMPOSE_PROJECT_NAME)_php_1 php artisan migrate:fresh --seed

sh:
	@docker exec -it $(COMPOSE_PROJECT_NAME)_${CONTAINER}_1 sh

ps:
	docker ps -f name=$(COMPOSE_PROJECT_NAME)

devdown:
	docker-compose down --remove-orphans

devclean: devdown
	sudo rm -rf .data
