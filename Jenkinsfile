pipeline {
    agent any
    environment {
        NODE_VERSION = '14.17.0'
        PHP_VERSION = '7.4'
        DOCKER_REGISTRY = 'mtariqueb'
        DOCKER_IMAGE = 'laravel-vue-app'
    }
    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/your-repo/laravel-vue-app.git']]])
            }
        }
        stage('Install Dependencies') {
            steps {
                sh 'docker run --rm -v $(pwd):/app -w /app node:${NODE_VERSION} npm install'
                sh 'docker run --rm -v $(pwd):/app -w /app composer:${PHP_VERSION} install --ignore-platform-reqs --no-ansi --no-interaction --no-scripts'
            }
        }
        stage('Build') {
            steps {
                sh 'docker build -t ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:latest .'
            }
        }
        stage('Test') {
            steps {
                sh 'docker run --rm -v $(pwd):/app -w /app node:${NODE_VERSION} npm run test'
                sh 'docker run --rm -v $(pwd):/app -w /app composer:${PHP_VERSION} run-script test'
            }
        }
        stage('Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    sh 'docker login ${DOCKER_REGISTRY} -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}'
                    sh 'docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:latest'
                }
            }
        }
        stage('Deploy') {
            steps {
                sh 'docker stack deploy --with-registry-auth -c docker-compose.yml ${DOCKER_IMAGE}'
            }
        }
    }
}
