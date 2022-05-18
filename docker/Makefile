IMAGE_PREFIX := workspace
OPTS := --mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
        --mount type=bind,src=$(HOME)/.local/share,dst=$(HOME)/.local/share

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
	docker run \
		-it $(IMAGE_PREFIX)_$(TARGET) \
		$(OPTS)
