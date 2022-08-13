# Base image
FROM python

#########
LABEL version="latest" maintainer="Dinesh Velhal <dinesh.velhal@gmail.com>"

# Install Robot Framework
RUN pip3 install robotframework==5.0.1
# Install Selenium library of of Robot Framework 
RUN pip3 install robotframework-seleniumlibrary

# Create working directory
RUN mkdir /working_dir

# Set the working directory
WORKDIR /working_dir

# robot command line will run when container starts
ENTRYPOINT ["robot"]