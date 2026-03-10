---
name: install-tooling
description: Install and verify gh, ripgrep, fzf, and jq tools needed for development workflows
---

# Development Tooling Installation

Install and verify essential development tools for Beatseek. Check for existing installations and guide through installing any missing tools.

### Required Tools

- **Homebrew** — Package manager for macOS/Linux
- **GitHub CLI (gh)** — GitHub pull request and issue management
- **ripgrep (rg)** — Fast code search
- **fzf** — Fuzzy finder for command line
- **jq** — JSON processor (useful for inspecting Spotify API responses)

### Installation Process

1. **Check Existing Installations**
   - For each tool, run the appropriate version command (`gh --version`, `rg --version`, etc.)
   - Report which tools are already installed and their versions
   - Skip installation for tools that are already present

2. **Install Homebrew (if needed)**
   - Provide the official installation command from `brew.sh`
   - **Wait for user confirmation** before proceeding

3. **Install Missing Tools**

   For each missing tool, **ask for user confirmation** before installation:

   ```bash
   brew install gh
   brew install ripgrep
   brew install fzf
   brew install jq
   ```

4. **Configure Tools (if needed)**
   - **GitHub CLI**: Run `gh auth login` to authenticate with GitHub
   - **fzf**: Run `$(brew --prefix)/opt/fzf/install` to set up shell key bindings

5. **Verify Installations**
   - Re-run version checks for all tools
   - Confirm all tools are accessible in PATH
   - Report any remaining issues

### Important Notes

- **User confirmation required** before installing Homebrew, any individual tool, or running auth commands
- If a Homebrew install fails, suggest the manual download as an alternative
