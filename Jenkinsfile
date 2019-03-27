pipeline {
  agent {
    docker {
      image 'openjdk:8-slim'
    }
  }
  stages {
    stage('Build') {
      steps {
        sh './gradlew buildServer'
        archiveArtifacts 'build/**/*.jar'
      }
    }
  }
}
