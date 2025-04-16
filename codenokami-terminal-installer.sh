#!/data/data/com.termux/files/usr/bin/bash

# === CodeNoKami Terminal Installer ===

echo "[*] Installing required packages..."
pkg update -y
pkg install -y nodejs git openssh curl

echo "[*] Creating plugin folder at ~/.codenokami_terminal..."
mkdir -p ~/.codenokami_terminal

# === Terminal Script Setup ===
echo "[*] Writing main terminal script..."
cat << 'EOF' > ~/.codenokami_terminal.sh
#!/data/data/com.termux/files/usr/bin/bash

echo "----------------------------------------"
echo "Welcome to CodeNoKami Terminal Session"
echo "Date: $(date)"
echo "----------------------------------------"
echo ""
echo "Running terminal session..."

# Simple interactive loop
while true; do
    echo -n "codenokami> "
    read -r cmd
    if [[ "$cmd" == "exit" ]]; then
        echo "Session closed."
        break
    fi
    eval "$cmd"
done
EOF

chmod +x ~/.codenokami_terminal.sh

# === Set up 'run-terminal' command ===
echo "[*] Setting up 'run-terminal' command..."

if ! grep -q "alias run-terminal=" ~/.bashrc; then
    echo 'alias run-terminal="bash ~/.codenokami_terminal.sh"' >> ~/.bashrc
    echo "[+] Added run-terminal alias to ~/.bashrc"
else
    echo "[!] 'run-terminal' already exists in ~/.bashrc"
fi

# Reload bashrc
echo "[*] Reloading bash configuration..."
source ~/.bashrc

# === Complete ===
echo ""
echo "========================================"
echo "✅ CodeNoKami Terminal installed!"
echo "➡ You can now run a terminal session with: run-terminal"
echo "========================================"
