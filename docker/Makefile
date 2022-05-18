IMAGE_PREFIX := workspace
OPTS := \
	--mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
	--mount type=bind,src=$(HOME)/.local/share,dst=$(HOME)/.local/share

.PHONY: help
help:
	@echo "docker環境を操作するタスクランナーです。"
	@echo ""
	@echo "tasks:"
	@echo "    make build TARGET=<target>   ... イメージをビルドする。"
	@echo "    make start TARGET=<target>   ... コンテナを立ち上げる。立ち上げるのに使うイメージが存在しないときはビルドもする。"
	@echo "    make stop  [TARGET=<target>] ... コンテナを停止する。TARGETを省略したらすべて停止する。"
	@echo "    make clean [TARGET=<target>] ... コンテナを削除する。TARGETを省略したらすべて削除する。"
	@echo ""
	@echo "targets:"
	@awk '/FROM/{print $$4}' Dockerfile | sed -E 's/^/    /'

.PHONY: build
build:
	docker build \
		--build-arg WORKUSER=$(USER) \
		--build-arg LOCAL_UID=`id -u` \
		--build-arg LOCAL_GID=`id -g` \
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
	# 停止済みのDockerプロセスが存在しないときは新規に起動する
	docker run \
		--name $(IMAGE_PREFIX)_$(TARGET) \
		$(OPTS) \
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
