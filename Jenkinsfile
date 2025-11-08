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

    stage('Deploy to K8s') {
      steps {
        echo '🚀 Deploying to Kubernetes...'
        withCredentials([usernamePassword(credentialsId: 'github-credentials', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PASS')]) {
          // Configure git
          bat 'git config --global user.email "jenkins@example.com"'
          bat 'git config --global user.name "Jenkins"'

          // Replace placeholder in deployment.yaml
          bat 'powershell -Command "(Get-Content k8s/deployment.yaml) -replace \'__BUILD_NUMBER__\', \'%BUILD_NUMBER%\' | Set-Content k8s/deployment.yaml"'
          
          // Add, commit, and push changes
          bat 'git add k8s/deployment.yaml'
          bat 'git commit -m "Update deployment to build %BUILD_NUMBER%"'
          bat 'git push https://%GIT_USER%:%GIT_PASS%@github.com/your-repo/your-project.git HEAD:main'
        }
        
        // Apply Kubernetes configurations
        bat 'kubectl apply -f k8s/'
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
