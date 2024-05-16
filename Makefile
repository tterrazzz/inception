DC_FILE	= ./srcs/docker-compose.yml

init_dir:
	mkdir -p ~/data/mariadb
	mkdir -p ~/data/wordpress
	mkdir -p ~/data/redis
	mkdir -p ~/data/uptime-kuma
	mkdir -p ~/data/static-website

start: init_dir
	@echo "Building and starting Docker containers and volumes"
	docker-compose -f $(DC_FILE) up -d --build

stop:
	@echo "Shutting down Docker containers"
	docker-compose -f $(DC_FILE) down

fclean:
	@echo "Removing volumes and built containers"
	docker volume rm $$(docker volume ls -q) && docker system prune -af

remove_db:
	@echo "Removing volumes content"
	rm -rf	~/data/mariadb \
		~/data/wordpress \
		~/data/redis \
		~/data/uptime-kuma \
		~/data/static-website

re: stop fclean start

.PHONY: start fclean re remove_db
