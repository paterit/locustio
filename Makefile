test:
	$(eval TMP_IMG_NAME := $(shell mktemp --dry-run XXXXXXXX | tr '[:upper:]' '[:lower:]'))
	docker build -t $(TMP_IMG_NAME) .
	docker rmi $(TMP_IMG_NAME)
