# Hello World Service
A service that greets people.

## Configuration
The HTTP port is set via the `deployment.port` value in `resources/application.conf`.

## HTTP endpoints
- `GET /`: Returns a greeting.

## Development
- `./gradlew test` will compile and run the zero unit tests.

## Running Locally
- `./gradlew buildServer` will build a JAR, including all runtime dependencies.
- `./gradlew runServer` will run the server, listening on `0.0.0.0:8080`, by default.

## Running in a Container
- `make prepare` will install some necessary dependencies to your Mac
- `make image.run` will use your local filesystem's `/var/run/docker.sock`

## Running in Minikube
- `make` targets minikube: building the jar on your local filesystem and loading minikube as the `docker-env` before building the server into a container image and running the service. The service is available external to the Virtualbox VM via K8s Ingress.
- `make` will also delete the whole `hello-world` namespace before doing this, ensuring relative separation of concerns between builds.
- `make mk.test` points to how a user can access the Ingress via the default Minikube IP address:

```
curl -H"Host:world.helloclue.com" -kL http://192.168.99.100/
```
