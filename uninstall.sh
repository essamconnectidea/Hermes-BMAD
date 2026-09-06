#!/usr/bin/env bash
# Hermes-BMAD Uninstaller

set -e

echo "This will remove Hermes-BMAD profiles and tools."
echo "  Profiles:   ~/.hermes/profiles/*-bmad/"
echo "  BMAD home:  ~/.hermes/bmad-home/"
echo "  BMAD clone: ~/.hermes/bmad-method/"
echo ""
read -rp "Continue? (y/N) " CONFIRM
if [ "$CONFIRM" != "y" ]; then
    echo "Aborted."
    exit 0
fi

echo "Removing profiles..."
for p in amelia-bmad smith-bmad mary-bmad john-bmad winston-bmad sally-bmad; do
    if [ -d "$HOME/.hermes/profiles/$p" ]; then
        rm -rf "$HOME/.hermes/profiles/$p"
        echo "  Removed $p"
    fi
done

echo "Removing BMAD home..."
rm -rf "$HOME/.hermes/bmad-home"

echo "Removing BMAD method clone..."
rm -rf "$HOME/.hermes/bmad-method"

echo "Removing CLI tools..."
rm -f "$HOME/.hermes/bin/bmad-init" "$HOME/.hermes/bin/bmad-upgrade"

echo ""
echo "Uninstall complete."