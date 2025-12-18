
#!/bin/sh
set -e

EXT_FILE="$HOME/hyprfiles/vscode/extensions.txt"

if [ $# -eq 0 ]; then
  echo "Usage: $0 backup|restore"
  exit 0
fi

case "$1" in
  backup)
    codium --list-extensions > "$EXT_FILE"
    echo "Extensions backed up to $EXT_FILE"
    ;;

  restore)
    if [ ! -f "$EXT_FILE" ]; then
      echo "Error: $EXT_FILE not found" >&2
      exit 1
    fi

    while IFS= read -r extension; do
      [ -z "$extension" ] && continue
      codium --install-extension "$extension" || true
    done < "$EXT_FILE"

    echo "Extensions restored"
    ;;

  *)
    echo "Invalid argument: $1" >&2
    echo "Usage: $0 backup|restore" >&2
    exit 1
    ;;
esac
