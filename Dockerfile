# Use the latest version of the Amazon Linux base image
FROM ubuntu

# Update all installed packages to thier latest versions
RUN apt-get update

# Install the unzip package, which we will use it to extract the web files from the zip folder
RUN apt-get install nginx -y


# Change directory to the html directory
WORKDIR /var/www/html

# Install Git
RUN apt-get install -y git

# Set the build argument directive
ARG PERSONAL_ACCESS_TOKEN
ARG GITHUB_USERNAME
ARG REPOSITORY_NAME
ARG WEB_FILE_NAME

# Use the build argument to set environment variables 
ENV PERSONAL_ACCESS_TOKEN=$PERSONAL_ACCESS_TOKEN
ENV GITHUB_USERNAME=$GITHUB_USERNAME
ENV REPOSITORY_NAME=$REPOSITORY_NAME


# Clone the GitHub repository
RUN git clone -b host-indication https://$PERSONAL_ACCESS_TOKEN@github.com/$GITHUB_USERNAME/$REPOSITORY_NAME.git

# Copy the web files into the HTML directory
RUN cp -av $REPOSITORY_NAME/. /var/www/html

RUN chmod +x insertip.sh

RUN ./insertip.sh

# Remove the repository we cloned
RUN rm -rf $REPOSITORY_NAME

# Expose the default Nginx ports
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]