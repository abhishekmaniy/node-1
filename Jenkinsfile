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

    stage('Run Server') {
      steps {
        echo '🚀 Starting the Node.js server...'
        bat 'nohup npm run dev &'
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
