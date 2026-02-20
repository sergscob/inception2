all:
	mkdir -p /home/sskobyak/data/wp
	mkdir -p /home/sskobyak/data/db
	docker compose -f ./docker-compose.yml up -d --build

down:
	docker compose -f ./docker-compose.yml down

re:
	mkdir -p /home/sskobyak/data/wp
	mkdir -p /home/sskobyak/data/db
	docker compose -f ./docker-compose.yml down -v
	docker compose -f ./docker-compose.yml up -d --build

clean:
	docker stop $$(docker ps -qa);\
	docker rm $$(docker ps -qa);\
	docker rmi -f $$(docker images -qa);\
	docker volume rm $$(docker volume ls -q);\
	docker network rm $$(docker network ls -q);\
	rm -rf /home/sskobyak/data/*

.PHONY: all re down clean 