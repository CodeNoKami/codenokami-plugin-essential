#!/data/data/com.termux/files/usr/bin/bash
# CodeNoKami Terminal Installer

echo "[+] Installing CodeNoKami Terminal Dependencies..."

# Ensure apt is up to date
pkg update -y && pkg upgrade -y

# Install required packages
pkg install -y nodejs

# Create plugin directory if not exists
mkdir -p ~/codenokami-terminal
cd ~/codenokami-terminal

# Create simple Socket.io terminal server (run-terminal)
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

# Make server executable
chmod +x run-terminal.js

# Create shell wrapper
cat << 'EOF' > run-terminal
node ~/codenokami-terminal/run-terminal.js
EOF

chmod +x run-terminal
mv run-terminal /data/data/com.termux/files/usr/bin/

echo "[✓] Installation complete. Run with: run-terminal"
