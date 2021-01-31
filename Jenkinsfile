properties([
    buildDiscarder(logRotator(artifactDaysToKeepStr: '1', artifactNumToKeepStr: '1', daysToKeepStr: '1', numToKeepStr: '1')),
    pipelineTriggers([pollSCM('H/20 * * * *'), [$class: 'PeriodicFolderTrigger', interval: '1d']]),
    [$class: 'GithubProjectProperty', displayName: '', projectUrlStr: 'https://github.com/aphex3k/docker-alpine-wireguard'],
    disableConcurrentBuilds()
])

pipeline {
    agent any
    options { timeout(time: 1, unit: 'HOURS') }
    environment {
        DOCKER_HUB_USERNAME=credentials('docker_hub_username')
        DOCKER_HUB_PASSWORD=credentials('docker_hub_password')
    }
    tools {
        dockerTool 'docker'
    }
    stages {
        stage('Notify') {
            steps {
                slackSend botUser: true, channel: '@mhenke', color: '#000000', iconEmoji: ':octocat:', message: "started ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)", tokenCredentialId: 'com.slack.mhenke.token', username: 'Octocat'
            }
        }
        stage('Checkout') {
            steps {
                checkout scm
                echo 'Clean'
                sh 'git clean -xdf'
            }
        }
        stage ('Build Version') {
            steps {
                script {
                    sh 'docker --version'
                }
            }
        }
        stage ('Build Dockerimage') {
            steps {
                script {
                    sh 'docker build --no-cache -t aphex3k/alpine-wireguard:latest .'
                }
            }
        }
        stage ('push image') {
            when { expression { return env.BRANCH_NAME == 'master' }  }
            steps {
                script {
                    sh "docker login --username ${DOCKER_HUB_USERNAME} --password ${DOCKER_HUB_PASSWORD}"
                    sh 'docker image push aphex3k/alpine-wireguard:latest'
                }
            }
        }
    }
    post {
        cleanup {
            sh 'git clean -xdf'            
        }
        success {
            slackSend botUser: true, channel: '@mhenke', color: '#00ff00', iconEmoji: ':octocat:', message: "succeeded ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)", tokenCredentialId: 'com.slack.mhenke.token', username: 'Octocat'
        }
        failure {
            slackSend botUser: true, channel: '@mhenke', color: '#ff0000', iconEmoji: ':octocat:', message: "failed ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)", tokenCredentialId: 'com.slack.mhenke.token', username: 'Octocat'
        }
    }
}
