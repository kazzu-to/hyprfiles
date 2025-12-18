
#!/usr/bin/env bash
set -euo pipefail

# ========= CONFIG =========
SSH_DIR="$HOME/.local/.ssh"
KEY_NAME="id_ed25519"
KEY_PATH="$SSH_DIR/$KEY_NAME"
CONFIG_PATH="$SSH_DIR/config"
EMAIL="${1:-}"

# ========= CHECKS =========
if ! command -v ssh >/dev/null 2>&1; then
  echo "❌ ssh not installed"
  exit 1
fi

if [[ -z "$EMAIL" ]]; then
  echo "Usage: $0 your_email@example.com"
  exit 1
fi

# ========= CREATE DIR =========
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

# ========= GENERATE KEY =========
if [[ ! -f "$KEY_PATH" ]]; then
  echo "🔐 Generating ed25519 key..."
  ssh-keygen -t ed25519 -f "$KEY_PATH" -C "$EMAIL"
else
  echo "✔ SSH key already exists: $KEY_PATH"
fi

chmod 600 "$KEY_PATH"
chmod 644 "$KEY_PATH.pub"

# ========= SSH CONFIG =========
if [[ ! -f "$CONFIG_PATH" ]]; then
  echo "📝 Creating SSH config..."
  cat > "$CONFIG_PATH" <<EOF
Host github.com
  HostName github.com
  User git
  IdentityFile $KEY_PATH
  IdentitiesOnly yes
EOF
else
  echo "✔ SSH config already exists"
fi

chmod 600 "$CONFIG_PATH"

# ========= EXPORT CONFIG ENV =========
SHELL_RC=""
if [[ -n "${BASH_VERSION:-}" ]]; then
  SHELL_RC="$HOME/.bashrc"
elif [[ -n "${ZSH_VERSION:-}" ]]; then
  SHELL_RC="$HOME/.zshrc"
fi

if [[ -n "$SHELL_RC" ]]; then
  if ! grep -q "SSH_CONFIG_FILE=.*\.local/.ssh/config" "$SHELL_RC"; then
    echo "🔧 Adding SSH_CONFIG_FILE to $SHELL_RC"
    echo 'export SSH_CONFIG_FILE="$HOME/.local/.ssh/config"' >> "$SHELL_RC"
  else
    echo "✔ SSH_CONFIG_FILE already set in $SHELL_RC"
  fi
fi

# ========= SSH AGENT =========
if ! ssh-add -l >/dev/null 2>&1; then
  echo "🚀 Starting ssh-agent..."
  eval "$(ssh-agent -s)"
fi

if ! ssh-add -l | grep -q "$KEY_PATH"; then
  ssh-add "$KEY_PATH"
else
  echo "✔ SSH key already loaded in agent"
fi

# ========= OUTPUT =========
echo
echo "✅ Setup complete!"
echo
echo "👉 Add this public key to GitHub:"
echo "--------------------------------"
cat "$KEY_PATH.pub"
echo "--------------------------------"
echo
echo "Then test with:"
echo "  ssh -T git@github.com"
