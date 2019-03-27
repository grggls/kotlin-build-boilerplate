# Hello World Service
A service that greets people.

## Configuration
The HTTP port is set via the `deployment.port` value in `resources/application.conf`.

## HTTP endpoints
- `GET /`: Returns a greeting.

## Development
- `./gradlew test` will compile and run the zero unit tests.

## Running
- `./gradlew buildServer` will build a JAR, including all runtime dependencies.
- `./gradlew runServer` will run the server, listening on `0.0.0.0:8080`, by default.
