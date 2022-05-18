.PHONY: build
build:
	docker build \
		--build-arg WORKUSER=$(USER) \
		--build-arg LOCAL_UID=`id -u` \
		--build-arg LOCAL_GID=`id -g` \
		-t workspace_$(TARGET) \
		--target $(TARGET) \
		.
