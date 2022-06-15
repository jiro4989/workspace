IMAGE_PREFIX := workspace
OPTS := \
	--dns=8.8.8.8 \
	--group-add $(shell awk -F : '$$1 == "docker"{ print $$3 }' /etc/group) \
	--mount type=bind,src=$(HOME)/Downloads,dst=$(HOME)/Downloads \
	--mount type=bind,src=$(HOME)/.netrc,dst=$(HOME)/.netrc,ro \
	--mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
	--mount type=bind,src=$(HOME)/.local/share,dst=$(HOME)/.local/share
BUILD_ARG := \
	--build-arg WORKUSER=$(USER) \
	--build-arg LOCAL_UID=$(shell id -u) \
	--build-arg LOCAL_GID=$(shell id -g) \
	--build-arg PASSWORD=$(PASSWORD) \
	--build-arg EMAIL=$(EMAIL)

.PHONY: help
help:
	@echo "docker環境を操作するタスクランナーです。"
	@echo ""
	@echo "tasks:"
	@echo "    make build TARGET=<target>   ... イメージをビルドする。"
	@echo "    make start TARGET=<target>   ... コンテナを立ち上げる。立ち上げるのに使うイメージが存在しないときはビルドもする。"
	@echo "    make stop  [TARGET=<target>] ... コンテナを停止する。TARGETを省略したらすべて停止する。"
	@echo "    make clean [TARGET=<target>] ... コンテナを削除する。TARGETを省略したらすべて削除する。"
	@echo "    make purne                   ... イメージをpruneする。"
	@echo ""
	@echo "targets:"
	@awk '/FROM/{print $$4}' Dockerfile | sed -E 's/^/    /'

.PHONY: build
build:
ifeq ($(NO_CACHE),true)
	# nimのときだけUbuntuのバージョンをすげ替える
	$(eval BUILD_ARG := $(BUILD_ARG) --no-cache)
endif
ifeq ($(TARGET),nim)
	# nimのときだけUbuntuのバージョンをすげ替える
	$(eval BUILD_ARG := $(BUILD_ARG) --build-arg UBUNTU_VERSION=20.04)
endif
ifneq ($(NO_VALIDATION),true)
	./script/validate_prerequirements.sh
endif
	DOCKER_BUILDKIT=1 docker build \
		$(BUILD_ARG) \
		-t $(IMAGE_PREFIX)_$(TARGET) \
		--target $(TARGET) \
		.

.PHONY: start
start:
ifeq ($(shell docker images -qa $(IMAGE_PREFIX)_$(TARGET)),)
	# イメージが存在しないときはビルドする
	make build
endif
ifeq ($(shell docker ps -aqf name=$(IMAGE_PREFIX)_$(TARGET)),)
ifeq ($(TARGET),java)
	$(eval OPTS := $(OPTS) -p 3350:3350 -p 3390:3390)
endif
	# 停止済みのDockerプロセスが存在しないときは新規に起動する
	docker run \
		$(OPTS) \
		--name $(IMAGE_PREFIX)_$(TARGET) \
		-it $(IMAGE_PREFIX)_$(TARGET)
else
	# 停止済みのDockerプロセスが存在したら起動してアクセスする
	docker start $(IMAGE_PREFIX)_$(TARGET)
	sleep 1
	docker exec -it $(IMAGE_PREFIX)_$(TARGET) tmux
endif

.PHONY: stop
stop:
ifeq ($(TARGET),)
	# ターゲット指定が無い場合はすべて停止する
	@awk '/FROM/{print "docker stop $(IMAGE_PREFIX)_" $$4}' Dockerfile | bash
else
	# ターゲット指定がある場合は1つだけ停止する
	docker stop $(IMAGE_PREFIX)_$(TARGET)
endif


.PHONY: clean
clean:
ifeq ($(TARGET),)
	# ターゲット指定が無い場合はすべて削除する
	@awk '/FROM/{print "docker rm -f $(IMAGE_PREFIX)_" $$4}' Dockerfile | bash
else
	# ターゲット指定がある場合は1つだけ削除する
	docker rm -f $(IMAGE_PREFIX)_$(TARGET)
endif

.PHONY: prune
prune:
	docker image prune -f
