pipeline {
  agent any

  tools {
    nodejs "node20"   // The name you gave in Jenkins NodeJS tool config
  }

  options {
    timestamps()
    ansiColor('xterm')
  }

  environment {
    BRANCH_NAME = "${env.BRANCH_NAME}"
  }

  stages {
    stage('Checkout') {
      steps {
        echo "🔄 Checking out branch: ${env.BRANCH_NAME}"
        checkout scm
      }
    }

    stage('Install Dependencies') {
      steps {
        echo '📦 Installing dependencies...'
        bat 'npm install'
      }
    }

    stage('Build') {
      steps {
        echo '🏗️ Compiling TypeScript...'
        bat 'npm run build'
      }
    }

    stage('Build & Push Docker') {
      steps {
        echo '� Building Docker image and pushing to Docker Hub...'
        withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
          // Build image tagged with build number
          bat 'docker build -t %DOCKERHUB_USER%/node-1-prod:%BUILD_NUMBER% .'

          // Login and push (Windows CMD style)
          bat 'echo %DOCKERHUB_PASS% | docker login -u %DOCKERHUB_USER% --password-stdin'
          bat 'docker push %DOCKERHUB_USER%/node-1-prod:%BUILD_NUMBER%'
        }
      }
    }

    stage('Deploy Confirmation') {
      steps {
        echo "✅ Build and deployed successfully for branch: ${env.BRANCH_NAME}"
      }
    }
  }

  post {
    success {
      echo "🎉 Pipeline finished successfully for branch: ${env.BRANCH_NAME}"
    }
    failure {
      echo "❌ Build failed for branch: ${env.BRANCH_NAME}"
    }
  }
}
