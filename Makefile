.PHONY: all build up down clean fclean re logs

all: build up

build:
	docker-compose  build

up:
	docker-compose -d

down:
	docker-compose  down

clean: down
	docker system prune -f

fclean: clean
	docker system prune -af
	docker volume prune -f

re: fclean all

logs:
	docker-compose -f
