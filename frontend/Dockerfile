FROM node:18-alpine

WORKDIR /app

# Copy only package.json (NOT package-lock.json) to force fresh install
COPY package.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application
COPY . .

# Expose port
EXPOSE 5173

# Start the development server
CMD ["npm", "run", "dev", "--", "--host"]