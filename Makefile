# --vars
BREW_DEPS=docker kubernetes-cli terraform jenv
BREW_TAPS=caskroom/versions
BREW_CASK_DEPS=java8

# --config
.DEFAULT_GOAL := mk.up

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

### make targets for working in local/laptop memory/filesystem
local.test:
	./gradlew test

local.build:
	./gradlew buildServer
	make local.test
	@echo; ls -la ./build/libs/hello-world-server.jar

local.run: prepcheck local.build
	./gradlew runServer &

local.quit:
	ps -ef | grep runServer | grep gradle | awk '{print $2}' | xargs kill -9

image.build: local.build
	docker build . --tag hello-world-server:local

image.run: image.build
	docker run -m512M --cpus 2 -it -p 8080:8080 --rm hello-world-server:local

### minikube commands follow
mk.start:
	minikube start
	minikube addons enable ingress
	sleep 1
	minikube status

mk.config:
	kubectl config use-context minikube
	kubectl cluster-info

mk.build:
	make local.build
	eval $$(minikube docker-env) && docker build . --tag hello-world-server:minikube

mk.apply: mk.build
	kubectl delete namespace/hello-world || true
	kubectl apply -f ./deploy.yaml
	kubectl get all --namespace hello-world

mk.test:
	curl -H"Host:world.helloclue.com" -kL http://192.168.99.100/ && echo

mk.up: mk.apply
	sleep 10
	make mk.test
