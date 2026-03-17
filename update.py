#!/usr/bin/env python3
"""
dotfiles update script — installs dependencies and symlinks config files.
"""

import os
import shutil
import subprocess
import sys
from pathlib import Path

DOTFILES = Path(__file__).parent.resolve()
HOME = Path.home()

# Explicit map of repo path → target symlink path
SYMLINKS = {
    ".zshrc": HOME / ".zshrc",
    ".zprofile": HOME / ".zprofile",
    "config/starship.toml": HOME / ".config" / "starship.toml",
    # Claude Code
    "claude/settings.json": HOME / ".claude" / "settings.json",
    "claude/settings.local.json": HOME / ".claude" / "settings.local.json",
    "claude/statusline-command.sh": HOME / ".claude" / "statusline-command.sh",
    "claude/skills/notebooklm": HOME / ".claude" / "skills" / "notebooklm",
    "claude/skills/obsidian-cli": HOME / ".claude" / "skills" / "obsidian-cli",
}

# Homebrew packages required
BREW_PACKAGES = ["starship", "fzf", "zsh-autosuggestions"]


def run(cmd: list[str], **kwargs) -> subprocess.CompletedProcess:
    return subprocess.run(cmd, check=True, **kwargs)


def confirm(prompt: str) -> bool:
    try:
        return input(f"{prompt} [y/N] ").strip().lower() == "y"
    except (EOFError, KeyboardInterrupt):
        return False


def ensure_homebrew() -> bool:
    if shutil.which("brew"):
        return True
    print("Homebrew not found.")
    if confirm("Install Homebrew?"):
        run(
            [
                "/bin/bash",
                "-c",
                '$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)',
            ]
        )
        return True
    return False


def ensure_brew_packages():
    result = subprocess.run(
        ["brew", "list", "--formula"], capture_output=True, text=True
    )
    installed = set(result.stdout.split())
    missing = [p for p in BREW_PACKAGES if p not in installed]
    if missing:
        print(f"Installing: {', '.join(missing)}")
        run(["brew", "install"] + missing)
    else:
        print("All dependencies already installed.")


def make_symlinks(force: bool):
    for src_rel, target in SYMLINKS.items():
        src = DOTFILES / src_rel
        if not src.exists():
            print(f"  SKIP  {src_rel} (not found in repo)")
            continue

        target.parent.mkdir(parents=True, exist_ok=True)

        if target.is_symlink() and target.resolve() == src:
            print(f"  OK    {target}")
            continue

        if target.exists() or target.is_symlink():
            if not force:
                print(f"  SKIP  {target} (exists, use --force to overwrite)")
                continue
            target.unlink()

        target.symlink_to(src)
        print(f"  LINK  {target} → {src}")


def git_pull():
    print("Pulling latest changes...")
    try:
        run(["git", "-C", str(DOTFILES), "pull", "--ff-only"])
    except subprocess.CalledProcessError:
        print("Warning: git pull failed, continuing with local files.")


def main():
    force = "--force" in sys.argv or "-f" in sys.argv

    if not force and not confirm(
        "This will install dependencies and symlink dotfiles into your home directory. Continue?"
    ):
        print("Aborted.")
        return

    git_pull()

    if not ensure_homebrew():
        print("Homebrew required. Exiting.")
        sys.exit(1)

    ensure_brew_packages()

    print("Symlinking config files:")
    make_symlinks(force)

    print("\nDone. Restart your shell or run: source ~/.zshrc")


if __name__ == "__main__":
    main()
