#!/usr/bin/env bash
set -euo pipefail

# Usage: check_updates.sh [--update]
# Fetch two remote HTMX skill docs and compare with local references.

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REF_DIR="$BASE_DIR/references"
URL1="https://raw.githubusercontent.com/bigskysoftware/htmx/refs/heads/four/src/skills/htmx-guidance.md"
URL2="https://raw.githubusercontent.com/bigskysoftware/htmx/refs/heads/four/src/skills/upgrade-from-htmx2.md"

UPDATE=false
if [[ ${1-} == "--update" ]]; then
  UPDATE=true
fi

mkdir -p "$REF_DIR"

tmp1=$(mktemp)
tmp2=$(mktemp)

trap 'rm -f "$tmp1" "$tmp2"' EXIT

echo "Fetching remote files..."
if ! curl -fsSL "$URL1" -o "$tmp1"; then
  echo "Erreur: impossible de récupérer $URL1" >&2
  exit 2
fi
if ! curl -fsSL "$URL2" -o "$tmp2"; then
  echo "Erreur: impossible de récupérer $URL2" >&2
  exit 2
fi

file1="$REF_DIR/htmx-guidance.md"
file2="$REF_DIR/upgrade-from-htmx2.md"

changed=false

echo "Vérification de htmx-guidance.md..."
if [ ! -f "$file1" ]; then
  echo "Fichier local absent: htmx-guidance.md"
  changed=true
else
  if ! cmp -s "$file1" "$tmp1"; then
    echo "Changements détectés dans htmx-guidance.md"
    changed=true
  else
    echo "Aucun changement dans htmx-guidance.md"
  fi
fi

echo "Vérification de upgrade-from-htmx2.md..."
if [ ! -f "$file2" ]; then
  echo "Fichier local absent: upgrade-from-htmx2.md"
  changed=true
else
  if ! cmp -s "$file2" "$tmp2"; then
    echo "Changements détectés dans upgrade-from-htmx2.md"
    changed=true
  else
    echo "Aucun changement dans upgrade-from-htmx2.md"
  fi
fi

if [ "$changed" = true ]; then
  if [ "$UPDATE" = true ]; then
    echo "Mise à jour des fichiers locaux..."
    cp "$tmp1" "$file1"
    cp "$tmp2" "$file2"
    echo "Mise à jour terminée."
  else
    echo "Changements détectés. Pour mettre à jour les fichiers locaux, relancez avec --update."
  fi
else
  echo "Aucune modification détectée."
fi

exit 0
