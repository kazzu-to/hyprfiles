
#!/usr/bin/env bash
set -euo pipefail

# ========= CONFIG =========
SSH_DIR="$HOME/.ssh"
KEY_NAME="id_ed25519"
KEY_PATH="$SSH_DIR/$KEY_NAME"
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

# ========= SSH AGENT =========
if ! ssh-add -l >/dev/null 2>&1; then
  eval "$(ssh-agent -s)"
fi

ssh-add "$KEY_PATH" >/dev/null 2>&1 || true

# ========= OUTPUT =========
echo
echo "✅ Setup complete!"
echo
echo "👉 Add this public key to GitHub:"
echo "--------------------------------"
cat "$KEY_PATH.pub"
echo "--------------------------------"
echo
echo "Test with:"
echo "  ssh -T git@github.com"
