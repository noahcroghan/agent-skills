#!/usr/bin/env bash
# Link each skill in this repo into the directories agents load skills from:
#
#   ~/.agents/skills/<name>   pi and other Agent Skills clients
#   ~/.claude/skills/<name>   Claude Code
#
# Existing skills in those directories are left alone. Re-run after adding,
# removing, or renaming a skill, or after moving this clone.
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
skills="$repo/skills"

link_into() {
	local dest="$1"

	# Older versions of this script linked the whole directory to $skills.
	# Replace that with a real directory so per-skill links don't land in the repo.
	if [ -L "$dest" ] && [ "$(cd "$dest" 2>/dev/null && pwd -P)" = "$(cd "$skills" && pwd -P)" ]; then
		rm "$dest"
		echo "replaced old directory link $dest"
	fi
	mkdir -p "$dest"

	local dir name target
	for dir in "$skills"/*/; do
		dir="${dir%/}"
		name="$(basename "$dir")"
		[ -f "$dir/SKILL.md" ] || continue
		target="$dest/$name"

		if [ -L "$target" ]; then
			[ "$(readlink "$target")" = "$dir" ] && continue
			# Replace broken links (e.g. after moving this clone); keep working ones.
			if [ -e "$target" ]; then
				echo "skip: $target already links to $(readlink "$target")" >&2
				continue
			fi
		elif [ -e "$target" ]; then
			echo "skip: $target already exists" >&2
			continue
		fi

		ln -sfn "$dir" "$target"
		echo "linked $target"
	done

	# Remove broken links left behind by skills deleted or renamed in this repo.
	local link
	for link in "$dest"/*; do
		[ -L "$link" ] && [ ! -e "$link" ] || continue
		case "$(readlink "$link")" in
		"$skills"/*)
			rm "$link"
			echo "removed stale $link"
			;;
		esac
	done
}

link_into "$HOME/.agents/skills"
link_into "$HOME/.claude/skills"
