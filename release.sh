#!/usr/bin/env bash
# release.sh — bump the plugin manifest version, validate, commit, tag, and push.
#
# Why: a plugin release means bumping the version string in TWO files in this
# repo so users see updates after `/plugin marketplace update`:
#   - plugins/phasefolio/.claude-plugin/plugin.json   ("version" field)
#   - .claude-plugin/marketplace.json                  (plugins[0].version)
#
# Note: .mcp.json no longer carries a version — the plugin uses HTTP transport
# direct to https://app.phasefolio.com/api/mcp, so the engine version is
# resolved at runtime by the live endpoint. Only bump THIS plugin when the
# manifest, README, or bundled skill changes.
#
# Usage:
#   ./release.sh 0.1.5            # bump, validate, commit, tag v0.1.5, push
#   ./release.sh 0.1.5 --no-push  # local only — useful for dry-runs
#   ./release.sh --help

set -euo pipefail

#─── arg parsing ──────────────────────────────────────────────────────────────
PUSH=1
NEW_VERSION=""
for arg in "$@"; do
  case "$arg" in
    --help|-h)
      sed -n '2,16p' "$0" | sed 's/^# //; s/^#//'
      exit 0
      ;;
    --no-push)
      PUSH=0
      ;;
    *)
      if [[ -n "$NEW_VERSION" ]]; then
        echo "error: too many arguments" >&2
        exit 2
      fi
      NEW_VERSION="$arg"
      ;;
  esac
done

if [[ -z "$NEW_VERSION" ]]; then
  echo "error: missing version. usage: ./release.sh <new-version> [--no-push]" >&2
  exit 2
fi

if ! [[ "$NEW_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[0-9A-Za-z.-]+)?$ ]]; then
  echo "error: version must look like X.Y.Z or X.Y.Z-prerelease (got: $NEW_VERSION)" >&2
  exit 2
fi

#─── locate repo root ─────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

PLUGIN_JSON="plugins/phasefolio/.claude-plugin/plugin.json"
MARKETPLACE_JSON=".claude-plugin/marketplace.json"

for f in "$PLUGIN_JSON" "$MARKETPLACE_JSON"; do
  [[ -f "$f" ]] || { echo "error: $f not found — are you running from the repo root?" >&2; exit 1; }
done

#─── preflight ────────────────────────────────────────────────────────────────
echo "── preflight ──"

# clean working tree
if [[ -n "$(git status --porcelain)" ]]; then
  echo "error: working tree is dirty. commit or stash first." >&2
  git status --short >&2
  exit 1
fi

# on main
BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [[ "$BRANCH" != "main" ]]; then
  echo "error: must be on main (currently on $BRANCH)." >&2
  exit 1
fi

# in sync with origin
git fetch -q origin main
LOCAL="$(git rev-parse main)"
REMOTE="$(git rev-parse origin/main)"
if [[ "$LOCAL" != "$REMOTE" ]]; then
  echo "error: main is out of sync with origin/main. pull or push first." >&2
  exit 1
fi

# tag must not already exist
if git rev-parse "v$NEW_VERSION" >/dev/null 2>&1; then
  echo "error: tag v$NEW_VERSION already exists." >&2
  exit 1
fi

# read current versions
CURRENT_PLUGIN_VERSION="$(python3 -c "import json; print(json.load(open('$PLUGIN_JSON'))['version'])")"
CURRENT_MARKETPLACE_VERSION="$(python3 -c "import json; print(json.load(open('$MARKETPLACE_JSON'))['plugins'][0]['version'])")"

if [[ "$CURRENT_PLUGIN_VERSION" != "$CURRENT_MARKETPLACE_VERSION" ]]; then
  echo "warning: plugin.json ($CURRENT_PLUGIN_VERSION) and marketplace.json ($CURRENT_MARKETPLACE_VERSION) are out of sync." >&2
fi

if [[ "$NEW_VERSION" == "$CURRENT_PLUGIN_VERSION" ]]; then
  echo "error: new version equals current version ($NEW_VERSION). nothing to do." >&2
  exit 1
fi

echo "  current plugin.json:        $CURRENT_PLUGIN_VERSION"
echo "  current marketplace.json:   $CURRENT_MARKETPLACE_VERSION"
echo "  bumping to:                 $NEW_VERSION"
echo ""

#─── bump versions ────────────────────────────────────────────────────────────
echo "── bumping ──"

python3 <<PY
import json, pathlib
for path, mutator in [
    ("$PLUGIN_JSON", lambda d: d.update({"version": "$NEW_VERSION"})),
    ("$MARKETPLACE_JSON", lambda d: d["plugins"][0].update({"version": "$NEW_VERSION"})),
]:
    p = pathlib.Path(path)
    d = json.loads(p.read_text())
    mutator(d)
    p.write_text(json.dumps(d, indent=2) + "\n")
    print(f"  updated {path}")
PY

#─── validate ─────────────────────────────────────────────────────────────────
echo ""
echo "── validating ──"

if ! command -v claude >/dev/null 2>&1; then
  echo "warning: 'claude' CLI not on PATH — skipping manifest validation." >&2
else
  claude plugin validate "$SCRIPT_DIR/plugins/phasefolio" >/dev/null
  echo "  ✔ plugin.json"
  claude plugin validate "$SCRIPT_DIR" >/dev/null
  echo "  ✔ marketplace.json"
fi

#─── commit, tag, push ────────────────────────────────────────────────────────
echo ""
echo "── committing ──"

git add "$PLUGIN_JSON" "$MARKETPLACE_JSON"
git commit -m "release: v$NEW_VERSION

Bump plugin manifest version from $CURRENT_PLUGIN_VERSION to $NEW_VERSION.
"
git tag -a "v$NEW_VERSION" -m "v$NEW_VERSION"

echo "  ✔ commit + tag created locally"

if [[ $PUSH -eq 1 ]]; then
  echo ""
  echo "── pushing ──"
  git push origin main
  git push origin "v$NEW_VERSION"
  echo "  ✔ pushed main + v$NEW_VERSION"
  echo ""
  echo "Released v$NEW_VERSION. Users get the update on \`/plugin marketplace update\`."
else
  echo ""
  echo "Skipped push (--no-push). To ship:"
  echo "  git push origin main && git push origin v$NEW_VERSION"
fi
