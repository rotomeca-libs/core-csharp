#!/usr/bin/env bash
# Aligne les dépendances du méta-package sur leurs dernières versions stables publiées sur NuGet
# et incrémente le patch de Rotomeca.Core si au moins une dépendance a changé.
#
# Usage : bump-dependencies.sh <csproj> [<package attendu> <version attendue>]
#   Si un package et une version sont fournis (repository_dispatch), le script attend
#   que cette version soit indexée par NuGet avant de comparer (jusqu'à ~15 min).
#
# Sorties (ajoutées à $GITHUB_OUTPUT si défini) : bumped=true|false, version=<nouvelle version>.
set -euo pipefail

csproj="$1"
wait_package="${2:-}"
wait_version="${3:-}"

dependencies=("Rotomeca.Core.Collections" "Rotomeca.Core.Optionals")
nuget="https://api.nuget.org/v3-flatcontainer"

output() {
  echo "$1"
  if [[ -n "${GITHUB_OUTPUT:-}" ]]; then echo "$1" >> "$GITHUB_OUTPUT"; fi
}

# Versions stables (sans suffixe de préversion) publiées, une par ligne, triées.
published_versions() {
  local id
  id="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
  { curl -fsSL "$nuget/$id/index.json" || true; } \
    | grep -oE '"[0-9]+\.[0-9]+\.[0-9]+"' | tr -d '"' | sort -V
}

latest_version() {
  published_versions "$1" | tail -n 1
}

# Le plus grand de deux numéros de version.
max_version() {
  printf '%s\n%s\n' "$1" "$2" | sort -V | tail -n 1
}

escape() {
  printf '%s' "$1" | sed 's/\./\\./g'
}

if [[ -n "$wait_package" && -n "$wait_version" ]]; then
  for attempt in $(seq 1 30); do
    if published_versions "$wait_package" | grep -qxF "$wait_version"; then
      echo "$wait_package $wait_version est disponible sur NuGet."
      break
    fi
    if [[ "$attempt" -eq 30 ]]; then
      echo "::error::$wait_package $wait_version n'est toujours pas indexé par NuGet." >&2
      exit 1
    fi
    echo "En attente de l'indexation de $wait_package $wait_version ($attempt/30)..."
    sleep 30
  done
fi

changed=false
for dependency in "${dependencies[@]}"; do
  pattern="$(escape "$dependency")"
  current="$(sed -nE "s/.*Include=\"$pattern\" Version=\"([^\"]+)\".*/\1/p" "$csproj" | head -n 1)"
  latest="$(latest_version "$dependency")"

  if [[ -z "$current" || -z "$latest" ]]; then
    echo "::error::Version introuvable pour $dependency (csproj: '$current', NuGet: '$latest')." >&2
    exit 1
  fi

  if [[ "$current" != "$latest" && "$(max_version "$current" "$latest")" == "$latest" ]]; then
    echo "$dependency : $current -> $latest"
    sed -i -E "s/(Include=\"$pattern\" Version=\")[^\"]+/\1$latest/" "$csproj"
    changed=true
  else
    echo "$dependency : $current (à jour)"
  fi
done

if [[ "$changed" != true ]]; then
  output "bumped=false"
  exit 0
fi

# On part de la plus grande version entre le csproj et NuGet pour ne jamais republier un numéro existant.
own_version="$(sed -nE 's/.*<Version>([0-9]+\.[0-9]+\.[0-9]+)<\/Version>.*/\1/p' "$csproj" | head -n 1)"
published_own="$(latest_version "Rotomeca.Core")"
base="$(max_version "$own_version" "${published_own:-0.0.0}")"
IFS=. read -r major minor patch <<< "$base"
next="$major.$minor.$((patch + 1))"

sed -i -E "s/<Version>[^<]+<\/Version>/<Version>$next<\/Version>/" "$csproj"
echo "Rotomeca.Core : $own_version -> $next"

output "bumped=true"
output "version=$next"
