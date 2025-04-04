#!/bin/bash

# Generate SQL files for the CERIF data model
echo "Generating SQL files for the CERIF data model..."

# Install dependencies
npm install

# Run the parse-cerif.js script
node parse-cerif.js

echo "SQL files generated successfully!"
