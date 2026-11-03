# Anti-Defensive Writing — General Edition v2.1

A general-purpose writing skill for removing unnecessary defensive framing while preserving meaning, evidence, uncertainty, constraints, and audience fit. It supports academic, professional, technical, policy, grant, and presentation writing. Evidence and research safeguards apply only when relevant to the task.

## Install

The installer defaults to the user-level Codex skills folder at $HOME/.agents/skills. It backs up an existing anti-defensive-writing folder before replacing it.

1. Extract this package.
2. Open a terminal in the extracted package folder.
3. Run:

    chmod +x install.sh
    ./install.sh

To choose another skills directory, pass it to the installer:

    ./install.sh --dest "$HOME/.codex/skills"

The backup is kept next to the installed skill with a UTC timestamp in its name. Review or remove that backup yourself when you no longer need it.

## Package contents

- SKILL.md — complete skill instructions
- install.sh — POSIX shell installer for macOS, Linux, and WSL
- README.md — these installation notes

The installer installs only SKILL.md. It does not run automatically when the archive is extracted.
