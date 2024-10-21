# Use an official Node.js image
FROM node:22.10.0

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json from two directories back (../../)
COPY ../../package.json ./
COPY ../../package-lock.json ./

RUN npm ci --only=production

# Copy the rest of the application from two directories back (../../)
COPY ../../ ./

EXPOSE 80

# Set the environment variable for the port
ENV NODE_ENV=production


# Run the app on port 80
CMD ["npm", "start"]

