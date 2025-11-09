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
          bat 'docker build -t %DOCKERHUB_USER%/node-1:%BUILD_NUMBER% .'

          // Login and push (Windows CMD style)
          bat 'echo %DOCKERHUB_PASS% | docker login -u %DOCKERHUB_USER% --password-stdin'
          bat 'docker push %DOCKERHUB_USER%/node-1:%BUILD_NUMBER%'
        }
      }
    }

    stage('Deploy to K8s (Dev)') {
      steps {
        echo '🚀 Updating Kubernetes deployment for development...'
        withCredentials([usernamePassword(credentialsId: 'github-credentials', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PASS')]) {
          // Configure Git identity
          bat 'git config --global user.email "abhishekmaniyar502@gmail.com"'
          bat 'git config --global user.name "abhishekmaniy"'

           // Update image tag in deployment.yaml
          bat """
            powershell -NoProfile -ExecutionPolicy Bypass -Command ^
            "$$content = Get-Content 'k8s/deployment.yaml' -Raw; ^
            $$content = $$content -replace 'image: abhishekmaniyar3811/node-1(:[\\w.-]+)?', 'image: abhishekmaniyar3811/node-1:%BUILD_NUMBER%'; ^
            Set-Content 'k8s/deployment.yaml' -Value $$content"
          """
          
          // Commit and push changes
          bat 'git add k8s/deployment.yaml'
          bat 'git commit -m "Update dev image tag to build %BUILD_NUMBER%" || echo No changes to commit'
          bat 'git push https://%GIT_USER%:%GIT_PASS%@github.com/abhishekmaniyar3811/node-repo-1.git HEAD:develop'
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
