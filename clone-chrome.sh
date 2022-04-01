#!/bin/bash

# The profile name is provided as an argument when running the script
PROFILE_NAME=$1

# Copy the Google Chrome application and append the profile name
cp -r "/Applications/Google Chrome.app" "/Applications/Google Chrome ${PROFILE_NAME}.app"

# Create a new directory for the new Chrome profile
mkdir -p "/Applications/Chrome ${PROFILE_NAME}.app/Contents/MacOS"

# Set a variable for the path of the new shell script
F="/Applications/Chrome ${PROFILE_NAME}.app/Contents/MacOS/Chrome ${PROFILE_NAME}"

# Start writing to the new shell script
cat > "$F" <<\EOF
#!/bin/bash
EOF

# Add the profile name to the shell script
echo "PROFILE_NAME='$PROFILE_NAME'" >> "$F"

# Continue writing to the shell script
cat >> "$F" <<\EOF

# Set the directory where the new profile's data will be stored
PROFILE_DIR="/Users/$USER/Library/Application Support/Google/Chrome/${PROFILE_NAME} Profile"

# Path of the new Chrome application
CHROME_BIN="/Applications/Google Chrome ${PROFILE_NAME}.app/Contents/MacOS/Google Chrome"

# Check if the new Chrome application exists
if [[ ! -e "$CHROME_BIN" ]]; then
  echo "ERROR: Can not find Google Chrome.  Exiting."
  exit -1
fi

# Launch the new Chrome application with the new profile
exec "$CHROME_BIN" --enable-udd-profiles --user-data-dir="$PROFILE_DIR"
EOF

# Make the new shell script executable
sudo chmod +x "$F"
