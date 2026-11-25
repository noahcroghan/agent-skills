#!/usr/bin/env bash
# Link this repo's skills into the places agents look for them.
#
#   ~/.agents/skills          -> <repo>/skills   (pi and other Agent Skills clients)
#   ~/.claude/skills/<name>   -> <repo>/skills/<name>   (Claude Code, one link per skill)
#
# Safe to re-run after adding or removing a skill.
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
skills="$repo/skills"

# ~/.agents/skills: one symlink to the whole skills directory.
agents="$HOME/.agents/skills"
mkdir -p "$(dirname "$agents")"
if [ -L "$agents" ]; then
	ln -sfn "$skills" "$agents"
elif [ -d "$agents" ] && [ -z "$(ls -A "$agents")" ]; then
	rmdir "$agents" && ln -s "$skills" "$agents"
elif [ -e "$agents" ]; then
	echo "error: $agents exists and is not a symlink or empty directory; move it aside first" >&2
	exit 1
else
	ln -s "$skills" "$agents"
fi
echo "linked $agents -> $skills"

# ~/.claude/skills: per-skill links, since that directory also holds other skills.
claude="$HOME/.claude/skills"
mkdir -p "$claude"
for dir in "$skills"/*/; do
	name="$(basename "$dir")"
	[ -f "$dir/SKILL.md" ] || continue
	target="$claude/$name"
	if [ -e "$target" ] && [ ! -L "$target" ]; then
		echo "skip: $target exists and is not a symlink" >&2
		continue
	fi
	ln -sfn "${dir%/}" "$target"
	echo "linked $target"
done

# Remove dangling Claude links that pointed into this repo (deleted skills).
for link in "$claude"/*; do
	[ -L "$link" ] || continue
	case "$(readlink "$link")" in
	"$skills"/*) [ -e "$link" ] || { rm "$link"; echo "removed stale $link"; } ;;
	esac
done
