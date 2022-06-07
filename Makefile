# -----------------------------------

# Variables
REDIS_TAG=3
REDIS_CONTAINER_NAME=redis
REDIS_IMAGE_NAME=redis

build_redis: ## Construcción y despliegue de redis
	@echo 'Construcción de redis con el TAG=$(REDIS_TAG)'
	docker pull $(REDIS_IMAGE_NAME):$(REDIS_TAG)
	@echo 'Ejecución de un contenedor de $(REDIS_IMAGE_NAME) con el nombre $(REDIS_CONTAINER_NAME)'
	docker run -d --name $(REDIS_CONTAINER_NAME) $(REDIS_IMAGE_NAME):$(REDIS_TAG)

# -----------------------------------
# Visualizar todas las imágenes de docker
# Visualizar contenedores activos
# Visualizar contenedores inactivos
# -----------------------------------

show_images_containers: ## Visualización de redis
	@echo 'Imágenes de docker'
	docker images -a
	@echo 'Contenedores en ejecución'
	docker ps --filter status=running
	@echo 'Contenedores fuera de ejecución'
	docker ps --filter status=exited

# -----------------------------------
# Eliminar el contenedor de redis
# Visualizar de nuevo 
# -----------------------------------

delete_redis: ## Eliminación de redis
	@echo 'Parar redis'
	docker stop $(REDIS_CONTAINER_NAME)
	@echo 'Eliminación del contenedor $(REDIS_CONTAINER_NAME)'
	docker rm $(REDIS_CONTAINER_NAME)
	@echo 'Eliminación de la imagen $(REDIS_IMAGE_NAME)'
	docker rmi $(REDIS_IMAGE_NAME):$(REDIS_TAG)
	@echo 'Imágenes de docker'
	docker images -a
	@echo 'Verificación de la eliminación'
	docker ps -a

# -----------------------------------
# 2. DESPLIEGUE DEL MONITOR
# -----------------------------------

# Construcción del monitor
build_monitor_prometheus:
	@echo 'Construcción y despliegue de Prometheus'
	cd monitor/prometheus && docker-compose up -d

build_monitor_grafana:
	@echo 'Construcción y despliegue de Grafana'
	cd monitor/grafana && docker-compose up -d

build_monitor_redis:
	@echo 'Construcción y despliegue de redis'
	cd monitor/redis && docker-compose up -d

build_monitor_redis_exporter:
	@echo 'Construcción y despliegue de redis-exporter'
	cd monitor/redis-exporter && docker-compose up -d

build_monitor: ## Construcción del monitor
	@echo 'Contenedores en ejecución'
	docker ps -a 
	$(MAKE) build_monitor_prometheus
	$(MAKE) build_monitor_grafana
	$(MAKE) build_monitor_redis
	$(MAKE) build_monitor_redis_exporter
	@echo 'Contenedores en ejecución'
	docker ps -a 

# Parar los servicios del monitor
stop_monitor_prometheus:
	@echo 'Parar el servicio de Prometheus'
	cd monitor/prometheus && docker-compose stop prometheus

stop_monitor_grafana:
	@echo 'Parar el servicio de Grafana'
	cd monitor/grafana && docker-compose stop grafana

stop_monitor_redis:
	@echo 'Parar el servicio de redis'
	cd monitor/redis && docker-compose stop redis

stop_monitor_redis_exporter:
	@echo 'Parar el servicio de redis'
	cd monitor/redis-exporter && docker-compose stop redis-exporter

stop_monitor: ## Para la ejecución de los conetendores del monitor
	@echo 'Contenedores en ejecución'
	docker ps -a
	$(MAKE) stop_monitor_prometheus
	$(MAKE) stop_monitor_grafana
	$(MAKE) stop_monitor_redis
	$(MAKE) stop_monitor_redis_exporter
	@echo 'Contenedores en ejecución'
	docker ps -a

# Eliminación de los servicios del monitor
down_monitor_prometheus:
	@echo 'Parar el servicio de Prometheus'
	cd monitor/prometheus && docker-compose down prometheus

down_monitor_grafana:
	@echo 'Parar el servicio de grafana'
	cd monitor/grafana && docker-compose down grafana

down_monitor_redis:
	@echo 'Parar el servicio de redis'
	cd monitor/redis && docker-compose down redis

down_monitor_redis_exporter:
	@echo 'Parar el servicio de redis-exporter'
	cd monitor/redis-exporter && docker-compose down redis-exporter

down_monitor: ## Eliminación de los contenedores del monitor
	@echo 'Contenedores en ejecución'
	docker ps -a
	$(MAKE) down_monitor_prometheus
	$(MAKE) down_monitor_grafana
	$(MAKE) down_monitor_redis
	$(MAKE) down_monitor_redis_exporter
	@echo 'Contenedores en ejecución'
	docker ps -a

# Proporciona ayuda
.PHONY: help
help: ## Comando de ayuda
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'
