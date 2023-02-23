# Base image
FROM node:18 as install
LABEL stage=install

# Create app directory
WORKDIR /src/install

# Copy npm files
COPY package.json .
COPY yarn.lock .

# Installs dependencies
RUN yarn install

# Compile using same image
FROM node:18 as compile
LABEL stage=compile

# Creates workspace
WORKDIR /src/build

# Copy file from last stage
COPY --from=install /src/install .
# Copy project remaining files
COPY . .

# Compile and install dependencies on production mode
RUN yarn build
RUN yarn install --production=true

# Use alpine version for last
FROM node:18-alpine as deploy

# Define the app directory
WORKDIR /app

# Copy node_modules and main.js
COPY --from=compile /src/build/dist/main.js index.js
COPY --from=compile /src/build/node_modules node_modules

# Run app
ENTRYPOINT node .