pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                checkout scm
            }
        }
        stage('Change Directory') {
            steps {
                // Changer de répertoire vers App/hello-world-app
                dir('App/hello-world-app') {
                    // Cette étape permet de changer le répertoire de travail pour les étapes suivantes
                    sh 'ls -la'  // Affiche les fichiers dans le répertoire pour vérification
                }
            }
        }
        stage('Install Dependencies') {
            steps {
                dir('App/hello-world-app') {
                    sh 'npm install'
                }
            }
        }
        stage('Build') {
            steps {
                dir('App/hello-world-app') {
                    sh 'npm run build'
                }
            }
        }
        stage('Test') {
            steps {
                dir('App/hello-world-app') {
                    sh 'npm test'
                }
            }
        }
        stage('Deploy') {
            steps {
                // Script pour copier les fichiers vers les VMs frontend
                sh '''
                scp -o StrictHostKeyChecking=no -r App/hello-world-app/build/* azureuser@52.178.5.218:/var/www/restoproch-frontend/
                scp -o StrictHostKeyChecking=no -r App/hello-world-app/build/* azureuser@52.174.138.254:/var/www/restoproch-frontend/
                '''
            }
        }
    }

    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed.'
        }
    }
}
