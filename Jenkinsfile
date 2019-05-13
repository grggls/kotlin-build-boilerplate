pipeline {
   agent {
      docker {
         image 'openjdk:8-slim'
      }
   }
   stages {
      stage('Build') {
         steps {
            make build
            archiveArtifacts 'build/**/*.jar'
         }
      }
      stage('Package') {
        steps {
          make image.build
        }
      }
   }
}
