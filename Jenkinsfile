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
                scp -r App/hello-world-app/build/* azureuser@adresse_ip_vm_front1:/var/www/restoproch-frontend/
                scp -r App/hello-world-app/build/* azureuser@adresse_ip_vm_front2:/var/www/restoproch-frontend/
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
