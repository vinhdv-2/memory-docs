FROM node:20-alpine

# Install pnpm
RUN npm install -g pnpm

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies using pnpm
RUN pnpm install

# Copy project files
COPY . .

# Expose port
EXPOSE 3000

# Start development server
CMD ["pnpm", "start", "--host", "0.0.0.0"]
