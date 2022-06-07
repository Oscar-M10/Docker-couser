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

# -----------------------------------
# DESPLIEGUE DE ELK
# -----------------------------------

build_elk: ## construcción y despliegue de ELK
	@echo 'construccion de ELK'
	cd ELK && docker-compose build
	@echo 'despliegue de ELK'
	cd ELK && docker-compose up -d 

stop_elk: ## Parar los servicios ELK
	@echo 'parar los servicios'
	cd ELK && docker-compose stop

start_elk: ## encender los servicios ELK
	@echo 'Encender los servicios ELK '
	cd ELK && docker-compose start

restart_elk: ## Reinicio de los servicios ELK
	@echo 'Reinicio de ELK'
	$(MAKE) stop_elk
	$(MAKE) start_elk
	docker ps 

##variables
ELASTICSEARCH_IMAGE="elasticsearch:7.9.2"
LOGSTASH_IMAGE="logstash:7.9.2"
KIBANA_IMAGE="kibana:7.9.2"

show: ## Mostrar imagenes y contenedores ELK
	@echo 'Eliminacion profunda de ELK'
	docker images -a
	@echo 'Contenedores en ejecucion'
	docker ps --filter status=running
	@echo 'Contenedores fuera de ejecucion'
	docker ps --filter status=exited

deep_delete: ## Eliminacion profunda
	$(MAKE) show_elk
	@echo 'Eliminacion de contenedores'
	cd ELK && docker-compose down
	@echo 'Purgación de las imagenes'
	docker rmi $(ELASTICSEARCH_IMAGE) $(LOGSTASH_IMAGE) $(KIBANA_IMAGE)
	$(MAKE) show_elk

# -----------------------------------
# 4. DESPLIGUE DE LA DAPP BLOCKCHAIN
# -----------------------------------

#variables
DAPP_IMAGE = tokensnft
DAPP_TAG = v1
DAPP_CONTAINER_NAME=tokens_nft


build_dapp: ## construccion de la DAPP
	@echo 'construccion de la DAPP'
	cd colores && docker build -t $(DAPP_IMAGE):$(DAPP_TAG) . 

run_dapp: ## Despliegue de la DAPP
	@echo 'Despliegue de la DAPP'
	docker run -dp 3000:3000 --name $(DAPP_CONTAINER_NAME) $(DAPP_IMAGE):$(DAPP_TAG)

stop_dapp: ## para la ejecucion de la DAPP
	@echo 'Parar la ejecucion de la DAPP'
	docker stop $(DAPP_CONTAINER_NAME)

restart_dapp: ## Reinicio de la DApp
	@echo 'Reinicio de la DApp'
	docker stop $(DAPP_CONTAINER_NAME)

delete_dapp: ## Depp delete
	@echo 'Reinicio de la DApp'
	$(MAKE) stop_dapp
	docker rm $(DAPP_CONTAINER_NAME)

show_requirements: ## Visualización de las dependencias de la DApp
	@echo 'Visualicacion de las dependencias de la DApp'
	docker run docker run -it $(DAPP_IMAGE:$(DAPP_TAG) bash

test_dapp: ## Test de la DApp
	@echo 'Test de la DApp'
	docker run -t $(DAPP_IMAGE):$(DAPP_TAG) test 
