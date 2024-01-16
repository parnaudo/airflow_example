local_dir ?= $(HOME)/Documents
build:
	docker-compose build
run:
	docker-compose up -d
stop:
	docker-compose stop
bash:
	docker exec -ite AIRFLOW__CORE__SQL_ALCHEMY_CONN="mysql://admin:admin@db:3306/airflow?charset=utf8mb4"  airflow-base-1 bash
log:
	docker logs -f airflow-base-1
destroy:
	docker-compose down -v
clean:
	docker container prune -f
	docker volume prune -f
