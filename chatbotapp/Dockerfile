# Use an Nginx image as the base
FROM nginx:alpine

# Copy built Angular files into Nginx HTML directory
COPY ./dist/chatbotapp /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
