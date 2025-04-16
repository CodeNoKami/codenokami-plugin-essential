#!/data/data/com.termux/files/usr/bin/bash

echo "Starting CodeNoKami Terminal setup..."

# Update package list
pkg update -y

# Install necessary packages
pkg install -y nodejs python git termux-api

# Optional: Other setup logic you want

# Create success flag file
touch ~/.codenokami_terminal_ready

# Create a run-terminal command
echo 'echo "CodeNoKami Terminal is running."' > /data/data/com.termux/files/usr/bin/run-terminal
chmod +x /data/data/com.termux/files/usr/bin/run-terminal

echo "Setup completed. You can now run 'run-terminal' to launch CodeNoKami Terminal."
