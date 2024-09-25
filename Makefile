.PHONY: deploy

include .env

auth:
	@echo "Authenticating with AWS ECR..."
	aws ecr get-login-password --region eu-south-1 | docker login --username AWS --password-stdin ${REPOSITORY}

build-web:
	docker build -t ${WEB_IMAGE} -f Dockerfile.web --build-arg PHP_VERSION=${WEB_PHP_VERSION} .
	docker tag ${WEB_IMAGE}:${WEB_IMAGE_TAG} ${REPOSITORY}/${WEB_IMAGE}:${WEB_IMAGE_TAG}

build-worker:
	docker build -t ${WORKER_IMAGE} -f Dockerfile.worker --build-arg PHP_VERSION=${WORKER_PHP_VERSION} .
	docker tag ${WORKER_IMAGE}:${WORKER_IMAGE_TAG} ${REPOSITORY}/${WORKER_IMAGE}:${WORKER_IMAGE_TAG}

build: build-web build-worker

push-web:
	docker push ${REPOSITORY}/${WEB_IMAGE}:${WEB_IMAGE_TAG}

push-worker:
	docker push ${REPOSITORY}/${WORKER_IMAGE}:${WORKER_IMAGE_TAG}

push: push-web push-worker