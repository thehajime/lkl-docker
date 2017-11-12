#
# This makefile is for local testing purposing only. The build and
# publishing happens and docker hub: https://hub.docker.com/r/lkldocker/
#

TARGETS := circleci circleci-android circleci-android-arm32 \
	circleci-android-arm64 circleci-mingw circleci-x86_64

#
# To publish a new tag modify the variables below, commit and then
# issue:
#
# $ make tag-<image>
#
# to generate the actual git tag.
#
# Although technically not needed, this allows us to easily track the
# tags in the git log and it makes sure that we kick the docker hub
# build (pushing just a tag apparently does not work).
#
TAG_circleci := 0.1
TAG_circleci-x86_64 := 0.1
TAG_circleci-mingw := 0.1
TAG_circleci-android := 0.1
TAG_circleci-android-arm32 := 0.0
TAG_circleci-android-arm64 := 0.0

all: $(TARGETS)

circleci:
	docker build -t lkldocker/$@:$(TAG_$@) $@

circleci-android: circleci/android
	docker build -t lkldocker/$@:$(TAG_$@) $^

circleci-android-arm32: circleci/android/arm32
	docker build -t lkldocker/$@:$(TAG_$@) $^

circleci-android-arm64: circleci/android/arm64
	docker build -t lkldocker/$@:$(TAG_$@) $^

circleci-mingw: circleci/mingw
	docker build -t lkldocker/$@:$(TAG_$@) $^

circleci-x86_64: circleci/x86_64
	docker build -t lkldocker/$@:$(TAG_$@) $^

tag-%:
	@if [ -z $(TAG_$*) ]; then \
		echo "unknown image $(*)"; \
	else \
		git tag $*-$(TAG_$*); \
	fi

.PHONY: $(TARGETS)
