//file:noinspection GroovyAssignabilityCheck
pipeline {

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
                        '--outputdir /working_dir/reports ' +
                        '/working_dir/tests/basicChecks.robot'
            }
//            post {
//                always {
//                    step(
//                            [
//                                    $class              : 'RobotPublisher',
//                                    outputPath          : 'robot-framework/results',
//                                    outputFileName      : "output.xml",
//                                    reportFileName      : 'report.html',
//                                    logFileName         : 'log.html',
//                                    disableArchiveOutput: true,
//                                    passThreshold       : 95.0,
//                                    unstableThreshold   : 90.0,
//                                    otherFiles          : "**/*.png,**/*.jpg",
//                            ]
//                    )
//                }
//            }
        }
    }
}