DV = docker volume
DC = docker-compose
DVLIST =
DC_FILE = ./srcs/docker-compose.yml

start:
	@echo "Building and starting Docker containers and volumes"
	$(DC) -f $(DC_FILE) up -d --build

stop:
	@echo "Shutting down Docker containers"
	$(DC) -f $(DC_FILE) down

fclean:
	@echo "Removing volumes and built containers"
	$(DV) rm "$(docker volume ls -q)" && docker system prune -af

remove_db:
	@echo "Removing volumes content"
	rm -rf ./srcs/requirements/mariadb/volume/* \
		./srcs/requirements/wordpress/volume/*

re: stop fclean start

.PHONY: start fclean re remove_db
