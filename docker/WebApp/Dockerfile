# Use an official Node.js image
FROM node:22.10.0

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json from two directories back (../../)
COPY ../../package.json ./
COPY ../../package-lock.json ./

# Copy the rest of the application from two directories back (../../)
COPY ../../ ./

# Expose the port (adjust as necessary)
EXPOSE 80

# Command to run the app
CMD ["npm", "run", "dev"]