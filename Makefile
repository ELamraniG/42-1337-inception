.PHONY: all build up down clean fclean re logs

all: build up

build:
	docker-compose -f srcs/docker-compose.yml build

up:
	docker-compose -f srcs/docker-compose.yml up -d

down:
	docker-compose -f srcs/docker-compose.yml down

clean: down
	docker system prune -f

fclean: clean
	docker system prune -af
	docker volume prune -f

re: fclean all

logs:
	docker-compose -f srcs/docker-compose.yml logs -f
