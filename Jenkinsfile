pipeline {
    agent any
    stages {
        stage('Clone Repository') {
            steps {
                // Clone le code source
                checkout scm
            }
        }
        stage('Install Dependencies') {
            steps {
                dir('App/hello-world-app') {  // Chemin vers ton application
                    sh 'npm install'
                }
            }
        }
        stage('Build Application') {
            steps {
                dir('App/hello-world-app') {
                    sh 'npm run build'
                }
            }
        }
        stage('Deploy Application') {
            steps {
                dir('App/hello-world-app') {
                    // Exécuter le script de déploiement ou copie vers les VMs
                    sh 'your-deployment-command-here'
                }
            }
        }
    }
}
