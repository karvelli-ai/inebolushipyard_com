#!/bin/bash

# Load environment variables from .env.local
if [ -f .env.local ]; then
  export $(grep -v '^#' .env.local | xargs)
fi

# Check if required variables are set
if [ -z "$FTP_HOST" ] || [ -z "$FTP_USER" ] || [ -z "$FTP_PASS" ]; then
  echo "Error: FTP credentials not found. Please set FTP_HOST, FTP_USER, and FTP_PASS in .env.local"
  exit 1
fi

echo "Deploying to $FTP_HOST..."

# Use lftp to mirror the dist folder to the remote public_html
lftp -c "
open -u $FTP_USER,$FTP_PASS $FTP_HOST;
set ssl:verify-certificate no;
mirror --reverse --delete --verbose ./dist ./public_html;
bye
"

echo "Deployment complete!"
