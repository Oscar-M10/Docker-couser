#--------------------------------
#1. CONSTRUCCIÓN DE REDIS
#--------------------------------

#---------------------------------
#construir una imagen de redis
#Asignar un nombre el contenedor
#Asignar un tag mendiante variable
#----------------------------------

REDIS_TAG=3
REDIS_CONTAINER_NAME=redis
REDIS_IMAGE_NAME=redis

#Construcción y despliegue de redis
build_redis:
	@echo 'Construccion de redis con el TAG=$(REDIS_TAG)'
	docker pull $(REDIS_IMAGE_NAME):$(REDIS_TAG)
	@echo 'Ejecucion de un contenedor de $(REDIS_IMAGE_NAME) con el nombre $(REDIS_CONTAINER_NAME)'
	docker run -d --name $(REDIS_CONTAINER_NAME) $(REDIS_IMAGE_NAME):$(REDIS_TAG)
#--------------------------------------
#Visualizar todas las imagenes de docker
#Visualizar contenedores activos
#visualizar contenedores inactivos
#----------------------------------------

#visualización
show_images_containers:
	@echo 'Imagenes de docker'
	docker images -a
	@echo 'Contenedores en Ejecucion'
	docker ps --filter status=running
	@echo 'Contenedores fuera de Ejecucion'
	docker ps --filter status=exited
#-------------------------------------------
#Eliminar el contenedor de redis
#Visualizar de nuevo
#-------------------------------------------

#Eliminacion de redis
delete_redis:
	@echo 'parar redis'
	docker stop $(REDIS_CONTAINER_NAME)
	@echo 'eliminacion del contenedor $(REDIS_IMAGE_NAME)'
	docker rm $(REDIS_CONTAINER_NAME)
	@echo 'Eliminacion d ela imgen $(REDIS_IMAGE_NAME)'
	docker rmi $(REDIS_IMAGE_NAME):$(REDIS_TAG)
	@echo 'Imagenes de docker'
	docker images -a
	@echo 'verificacion de la eliminacion'
	docker ps -a
#--------------------------------
#2. CONSTRUCCIÓN DE REDIS
#--------------------------------

#construcción de monitor
build_monitor_prometheus:
	@echo 'Construccion y despliegue de prometheus'
	cd monitor/prometheus && docker-compose up -d 

build_monitor_grafana:
	@echo 'Construccion y despliegue de prometheus'
	cd monitor/grafana && docker-compose up -d

build_monitor_redis:
	@echo 'Construccion y despliegue de prometheus'
	cd monitor/redis && docker-compose up -d

build_monitor_redis_exporter:
	@echo 'Construccion y despliegue de prometheus'
	cd monitor/redis-exporter && docker-compose up -d

build_monitor: 
	@echo 'Contenedores en ejecucion'
	docker ps -a 
	$(MAKE) build_monitor_prometheus
	$(MAKE) build_monitor_grafana
	$(MAKE) build_monitor_redis
	$(MAKE) build_monitor_redis_exporter
	docker ps -a
#Parar los servicios del monitor
stop_monitor_prometheus:
	@echo 'Parar el servicio de prometheus'
	cd monitor/prometheus && docker-compose stop prometheus
stop_monitor_grafana:
	@echo 'Parar el servicio de grafana'
	cd monitor/grafana && docker-compose stop grafana
stop_monitor_redis:
	@echo 'Parar el servicio de redis'
	cd monitor/redis && docker-compose stop redis
stop_monitor_redis_exporter:
	@echo 'Parar el servicio de redis-exporter'
	cd monitor/redis-exporter && docker-compose stop redis-exporter
stop_monitor:
	@echo 'Contenedores en ejecucion'
	docker ps -a 
	$(MAKE) stop_monitor_prometheus
	$(MAKE) stop_monitor_grafana
	$(MAKE) stop_monitor_redis
	$(MAKE) stop_monitor_redis_exporter

#Eliminación de los servicios del monitor
down_monitor_prometheus:
	@echo 'Parar el servicio de prometheus'
	cd monitor/prometheus && docker-compose down prometheus
down_monitor_grafana:
	@echo 'Parar el servicio de grafana'
	cd monitor/grafana && docker-compose down grafana
down_monitor_redis:
	@echo 'Parar el servicio de redis'
	cd monitor/redis && docker-compose down redis
down_monitor_redis_exporter:
	@echo 'Parar el servicio de redis exporter'
	cd monitor/redis-exporter && docker-compose down redis-exporter
down_monitor:
	@echo 'Contenedores en ejecucion'
	docker ps -a 
	$(MAKE) down_monitor_prometheus
	$(MAKE) down_monitor_grafana
	$(MAKE) down_monitor_redis
	$(MAKE) down_monitor_redis_exporter
	@echo 'Contenedores en ejecucion'
	docker ps -a 
