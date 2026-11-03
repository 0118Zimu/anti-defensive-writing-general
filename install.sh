#!/bin/sh
set -eu

skill_name=anti-defensive-writing
dest_dir=${HOME:?'HOME must be set to choose the default installation directory'}/.agents/skills

usage() {
    cat <<'EOF'
Usage: install.sh [--dest SKILLS_DIRECTORY]

Install anti-defensive-writing/SKILL.md under SKILLS_DIRECTORY.
Default: $HOME/.agents/skills
An existing installation is moved to a timestamped backup before replacement.
EOF
}

while [ "$#" -gt 0 ]; do
    case "$1" in
        --dest)
            [ "$#" -ge 2 ] || { echo "Missing directory after --dest" >&2; exit 2; }
            dest_dir=$2
            shift 2
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        *)
            echo "Unknown argument: $1" >&2
            usage >&2
            exit 2
            ;;
    esac
done

[ -n "$dest_dir" ] || { echo "Destination directory cannot be empty" >&2; exit 2; }
case "$dest_dir" in
    -* ) dest_dir=./$dest_dir ;;
esac
case "$dest_dir" in
    /) ;;
    */) dest_dir=${dest_dir%/} ;;
esac

script_dir=$(CDPATH= cd "$(dirname "$0")" && pwd -P)
source_skill=$script_dir/SKILL.md
[ -f "$source_skill" ] || { echo "Skill file not found: $source_skill" >&2; exit 1; }

mkdir -p "$dest_dir"
target=$dest_dir/$skill_name
stage_dir=$(mktemp -d "$dest_dir/.$skill_name.install.XXXXXX")
backup_path=
target_installed=0

cleanup() {
    result=$?
    trap - EXIT HUP INT TERM
    if [ "$target_installed" -eq 0 ] && [ -n "$backup_path" ] && { [ -e "$backup_path" ] || [ -L "$backup_path" ]; } && ! { [ -e "$target" ] || [ -L "$target" ]; }; then
        if mv "$backup_path" "$target"; then
            echo "Restored previous installation after an unsuccessful replacement." >&2
        else
            echo "Could not restore previous installation. Backup remains at: $backup_path" >&2
        fi
    fi
    if [ -n "$stage_dir" ] && [ -d "$stage_dir" ]; then
        rm -rf "$stage_dir"
    fi
    exit "$result"
}
trap cleanup EXIT
trap 'exit 1' HUP INT TERM

mkdir "$stage_dir/$skill_name"
cp "$source_skill" "$stage_dir/$skill_name/SKILL.md"
chmod 755 "$stage_dir/$skill_name"
chmod 644 "$stage_dir/$skill_name/SKILL.md"

if [ -e "$target" ] || [ -L "$target" ]; then
    stamp=$(date -u +%Y%m%dT%H%M%SZ)
    backup_path=$target.backup.$stamp
    suffix=1
    while [ -e "$backup_path" ] || [ -L "$backup_path" ]; do
        backup_path=$target.backup.$stamp.$suffix
        suffix=$((suffix + 1))
    done
    mv "$target" "$backup_path"
fi

mv "$stage_dir/$skill_name" "$target"
target_installed=1
echo "Installed to: $target"
if [ -n "$backup_path" ]; then
    echo "Previous installation backed up to: $backup_path"
fi
