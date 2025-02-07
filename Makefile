APP_PORT ?= 8080


.PHONY: build
build:
	./gradlew build

.PHONY: test
test:
	./gradlew test

.PHONY: start-api
start-api:
	SERVER_PORT=$(APP_PORT) ./gradlew bootRun

.PHONY: start
start: start-api

.PHONY: clean
clean:
	./gradlew clean
	rm -rf bin
