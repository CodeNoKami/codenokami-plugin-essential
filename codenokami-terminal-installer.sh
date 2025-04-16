#!/data/data/com.termux/files/usr/bin/bash

# Title: CodeNoKami Terminal Installer
# Usage: bash installer.sh

echo "[+] Installing CodeNoKami Terminal Dependencies..."

# Install required packages
pkg install -y nodejs

# Create plugin directory
mkdir -p ~/codenokami-terminal
cd ~/codenokami-terminal

# Create run-terminal.js script
cat << 'EOF' > run-terminal.js
const { Server } = require("socket.io");
const http = require("http");
const { spawn } = require("child_process");

const server = http.createServer();
const io = new Server(server, { cors: { origin: "*" } });

io.on("connection", (socket) => {
  console.log("[+] Client connected");

  socket.on("command", ({ sessionId, command }) => {
    const shell = spawn("sh", ["-c", command], { cwd: process.env.HOME });

    shell.stdout.on("data", (data) => {
      socket.emit("output", { sessionId, output: data.toString(), prompt: false });
    });

    shell.stderr.on("data", (data) => {
      socket.emit("output", { sessionId, output: data.toString(), prompt: false });
    });

    shell.on("close", () => {
      socket.emit("output", { sessionId, output: `\n$ `, prompt: true });
    });
  });
});

server.listen(5050, () => {
  console.log("[+] CodeNoKami Terminal running on port 5050");
});
EOF

# Make server script executable
chmod +x run-terminal.js

# Install required Node.js modules
npm install socket.io

# Create shell wrapper for Termux command
cat << 'EOF' > run-terminal
node ~/codenokami-terminal/run-terminal.js
EOF

chmod +x run-terminal
mv run-terminal /data/data/com.termux/files/usr/bin/

echo "[✓] Installation complete. Run with: run-terminal"
