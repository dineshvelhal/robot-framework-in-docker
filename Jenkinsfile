//file:noinspection GroovyAssignabilityCheck
pipeline {
    agent none

    stages {
        stage('Robot Framework') {
            agent {
                docker {
                    image 'dineshv/robotframework:latest'
                    args "--entrypoint=''"
                }
            }
            steps {
                sh 'robot ' +
                        '--outputdir reports ' +
                        'tests/basicChecks.robot'
            }
            post {
                always {
                    step(
                            [
                                    $class              : 'RobotPublisher',
                                    outputPath          : 'reports',
                                    outputFileName      : "output.xml",
                                    reportFileName      : 'report.html',
                                    logFileName         : 'log.html',
                                    disableArchiveOutput: true,
                                    passThreshold       : 95.0,
                                    unstableThreshold   : 90.0,
                                    otherFiles          : "**/*.png,**/*.jpg",
                            ]
                    )
                }
            }
        }
    }
}