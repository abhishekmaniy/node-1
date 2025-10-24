pipeline {
  agent any

  options {
    timestamps()
    ansiColor('xterm')
  }

  environment {
    // Jenkins automatically sets this for multibranch pipelines
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
        sh 'npm install'
      }
    }

    stage('Build') {
      steps {
        echo '🏗️ Building the application...'
        sh 'npm run build'
      }
    }

    stage('Run Server') {
      steps {
        echo '🚀 Starting the server...'
        // Run your app in the background (non-blocking)
        sh 'nohup npm run dev &'
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
