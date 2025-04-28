# Step 1: Use an official Node.js runtime as a parent image
FROM node:22-alpine3.20 AS build

# Step 2: Set the working directory
WORKDIR /app

# Step 3: Copy package.json and pnpm-lock.yaml to the working directory
COPY package.json pnpm-lock.yaml ./

# Step 4: Install pnpm (if not already installed)
RUN npm install -g pnpm

# Step 5: Install the dependencies
RUN pnpm install

# Step 6: Copy the rest of your application code
COPY . .

# Step 7: Build the app for production
RUN pnpm run build

# Step 8: Create a production-ready image using Nginx
FROM nginx:alpine

# Step 9: Copy the build files from the build stage
COPY --from=build /app/dist /usr/share/nginx/html

# Step 10: Expose the port Nginx is running on
EXPOSE 80

# Step 11: Start the Nginx server
CMD ["nginx", "-g", "daemon off;"]
