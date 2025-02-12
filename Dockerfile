# Use an official Nginx image to serve the static content
FROM nginx:alpine

# Copy the static content into the Nginx server's directory
COPY index.html /usr/share/nginx/html

# Expose port 80 to allow access to the app
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]

