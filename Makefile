.PHONY: all build up down clean fclean re logs

all: build up

build:
	sudo mkdir -p /home/moel-amr/data/mariadb /home/moel-amr/data/wordpress
	sudo docker compose -f srcs/docker-compose.yml build

up:
	sudo docker compose -f srcs/docker-compose.yml up -d

down:
	sudo docker compose -f srcs/docker-compose.yml down

clean: down
	sudo docker system prune -f

fclean: clean
	sudo docker system prune -af
	sudo docker volume prune -f
	sudo rm -rf /home/moel-amr/data/mariadb /home/moel-amr/data/wordpress
	
re: fclean all

logs:
	sudo docker compose -f srcs/docker-compose.yml logs -f
