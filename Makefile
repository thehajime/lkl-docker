#
# This makefile is for local testing purposing only. The build and
# publishing happens and docker hub: https://hub.docker.com/r/lkldocker/
#

TARGETS := circleci circleci-android circleci-android-arm32 \
	circleci-android-arm64 circleci-mingw circleci-x86_64
TAG ?= dev

all: $(TARGETS)

circleci: 
	docker build -t lkldocker/$@:$(TAG) $@

circleci-android: circleci/android
	docker build -t lkldocker/$@:$(TAG) $^

circleci-android-arm32: circleci/android/arm32
	docker build -t lkldocker/$@:$(TAG) $^

circleci-android-arm64: circleci/android/arm64
	docker build -t lkldocker/$@:$(TAG) $^

circleci-mingw: circleci/mingw
	docker build -t lkldocker/$@:$(TAG) $^

circleci-x86_64: circleci/x86_64
	docker build -t lkldocker/$@:$(TAG) $^

.PHONY: $(TARGETS)
