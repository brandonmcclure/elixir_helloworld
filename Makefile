ifeq ($(OS),Windows_NT)
	SHELL := pwsh.exe
else
	SHELL := pwsh
endif

.SHELLFLAGS := -NoProfile -Command

REGISTRY_NAME := registry.mcd.com/
REPOSITORY_NAME := bmcclure89/
IMAGE_NAME := elixirdemo
TAG := :latest

# Run Options
RUN_PORTS := -p 4000:4000

PLATFORMS := linux/amd64,linux/arm64,linux/arm/v7

.PHONY: all test clean lint
all: build

getcommitid:
	$(eval COMMITID = $(shell git log -1 --pretty=format:'%H'))

getbranchname:
	$(eval BRANCH_NAME = $(shell (git branch --show-current ) -replace '/','.'))

build: getcommitid getbranchname
	docker build -t $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME)$(TAG) -t $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME):$(BRANCH_NAME) -t $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME):$(BRANCH_NAME)_$(COMMITID) .

build_multiarch:
	docker buildx build -t $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME)$(TAG) --platform $(PLATFORMS) .
mix_%:
	docker run --workdir /mnt -v $${PWD}:/mnt $(RUN_PORTS) $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME)$(TAG) $*
docker_network:
	-docker network create elixir
run: build docker_network
	docker run -d --network elixir $(RUN_PORTS) $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME)$(TAG)
run_it: build
	docker run --rm --network elixir --entrypoint /bin/sh -it $(RUN_PORTS) -v $${PWD}/src/hello_pheonix:/src $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME)$(TAG)

package:
	$$PackageFileName = "$$("$(IMAGE_NAME)" -replace "/","_").tar"; docker save $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME)$(TAG) -o $$PackageFileName

size:
	docker inspect -f "{{ .Size }}" $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME)$(TAG)
	docker history $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME)$(TAG)

publish:
	docker login; docker push $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME)$(TAG); docker logout

lint: lint_mega lint_credo

lint_mega:
	docker run -v $${PWD}:/tmp/lint oxsecurity/megalinter:v6
lint_goodcheck:
	docker run -t --rm -v $${PWD}:/work sider/goodcheck check
lint_goodcheck_test:
	docker run -t --rm -v $${PWD}:/work sider/goodcheck test
lint_credo: 
	docker run --rm -v $${PWD}:/home/credo/code -t renderedtext/credo

test:
	echo 'Test not implemented'
clean: compose_clean
	Remove-Item megalinter-reports -Recurse


CORE_SERVICES := db adminer app
ALL_SERVICES := ${CORE_SERVICES} 

COMPOSE_ALL_FILES := ${CORE_SERVICES_FILES}
CORE_SERVICES_FILES := -f docker-compose.yml

# --------------------------

compose_core:
	@docker-compose ${COMPOSE_CORE_FILES} up -d --build ${CORE_SERVICES}

compose_down:
	@docker-compose ${COMPOSE_ALL_FILES} down

compose_stop:
	@docker-compose ${COMPOSE_ALL_FILES} stop ${ALL_SERVICES}

compose_restart:
	@docker-compose ${COMPOSE_ALL_FILES} restart ${ALL_SERVICES}

compose_rm:
	@docker-compose $(COMPOSE_ALL_FILES) rm -f ${ALL_SERVICES}

compose_logs:
	@docker-compose $(COMPOSE_ALL_FILES) logs --follow --tail=1000 ${ALL_SERVICES}

compose_images:
	@docker-compose $(COMPOSE_ALL_FILES) images ${ALL_SERVICES}

compose_clean: ## Remove all Containers and Delete Volume Data
	@docker-compose ${COMPOSE_ALL_FILES} down -v
k_apply:
	kubectl apply -f $${PWD}/k8s