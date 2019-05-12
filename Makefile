# --vars
BREW_DEPS=docker kubernetes-cli terraform jenv
BREW_TAPS=caskroom/versions
BREW_CASK_DEPS=java8

# --config
.DEFAULT_GOAL := local.run

# --targets
unprepare:
	brew uninstall --force $(BREW_DEPS)
	brew cask uninstall $(BREW_CASK_DEPS)

prepare: # this will error if not running the latest versions
	brew update
	brew install $(BREW_DEPS)
	brew tap $(BREW_TAPS)
	brew cask install $(BREW_CASK_DEPS)
	$(info "$$(jenv init -)")
	jenv add $$(/usr/libexec/java_home -v 1.8 )

prepcheck: prepare
	docker --version
	kubectl version
	terraform --version
	java -version

reprepare: unprepare prepare

local.test:
	./gradlew test

local.build:
	./gradlew buildServer
	@echo; ls -la ./build/libs/hello-world-server.jar

local.run: prepcheck local.build
	./gradlew runServer &

local.quit:
	ps -ef | grep runServer | grep gradle | awk '{print $2}' | xargs kill -9

image.build:
	docker build . --tag kotlin-boiler:local
