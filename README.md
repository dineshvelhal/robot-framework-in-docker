# Easiest way to run Robot Framework in Docker!

Recently I was working on a Proof of Concept of using Robot Framework as part of Jenkins pipeline. I could see that the resources on this topic are quite scattered so here I am summarizing my experience of creating a Docker image of Robot Framework and integrating it with Jenkins Pipeline.

## Containerizing the Robot Framework
Robot framework is based on Python, so obviously you need to start with the Python base image. I used the official Python 3.10 image from Docker Hub. Then I added the Robot Framework & its Selenium Library using the `pip` command. Then I created a directory `/working_dir` to act as default directory when mapping the scripts & reports from outside the container. Finally I set the `robot` command as the entrypoint. This enables the container to run `robot` command by default when it's instantiated. This last point is important if you want to quickly try running the tests from command line as part of `docker container run` command.
The final `Dockerfile` looks like [this](Dockerfile).


The Docker image is available in the Hub and can be pulled using the command:

`docker image pull dineshvelhal/robot-framework:latest`

Alternatively, you can clone this repo and then from inside the repo directory, create your own image by modfying the `Dockerfile` to suit your requirements.
```bash
git clone https://github.com/dineshvelhal/robot-framework-in-docker.git

cd robot-framework-in-docker

docker image build -t <your-docker-id>/<your-image-name>:<tag> . 
```

## How to use the container to run tests from Command line
This repo contains sample tests to quickly verify if the image is working as expected. You can do so by using this command:
```bash
# Make sure you are in the git repo directory
docker container run --rm -v <full-path-of-current-directory>:/working_dir  dineshvelhal/robot-framework:latest --outputdir reports tests/basicChecks.robot
```
In this command, we are mapping the current directory (containing the tests) to the working directory (`/working_dir`) inside the container through the volumes feature of Docker (the `-v` option).

## Running tests through Jenkins Pipeline

It's very easy to add the Robot tests to Jenkins pipeline by using the Docker agent. A typical stage in the pipeline looks like this:

```groovy
    stage('Robot Framework') {
        agent {
            docker {
                image 'dineshv/robotframework:latest'
                args '--entrypoint=""'
            }
        }
        steps {
            sh 'robot --outputdir reports tests/basicChecks.robot'
        }
    }
```
The `--entrypoint=""` argument is required for overriding the default robot invocation when the container starts. Jenkins takes care of robot command invocation as part of the `steps` execution.
You can install the Robot Framework Jenkins plugin for detailed reporting in the Jenkins builds. For that, open the Jenkins UI and go to `Dashboard --> Manage jenkins --> Available Plugins tab` and then searching & installing the Robot Framework Plugin. 
Once installed, you can make use of it in the pipeline `post`/`always` step as hown below:
```groovy
    stage('Robot Framework') {
        agent {
            docker {
                image 'dineshv/robotframework:latest'
                args '--entrypoint=""'
            }
        }
        steps {
            sh 'robot --outputdir reports tests/basicChecks.robot'
        }
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
```

Sample report from Jenkins:
![Jenkins Build](jenkins.JPG)



