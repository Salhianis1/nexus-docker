# Use the official Nginx image based on Alpine Linux
FROM nginx:alpine

# Copy the contents of the current directory (.) into the container's Nginx HTML directory
COPY . /usr/share/nginx/html

# Expose port 80, where Nginx serves the content
EXPOSE 80
