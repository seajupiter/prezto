# Personal Prezto Configuration

This is my personal [Prezto][1] configuration - a powerful Zsh framework that provides a solid foundation with sane defaults, aliases, functions, auto-completion, and prompt themes.

## Features

### 🚀 **Performance Optimized**
- **Lazy loading** for zoxide, thefuck, and ghcup
- **Fast completion** with optimized compinit caching
- **Efficient startup** with minimal overhead

### 🔍 **Enhanced Search & Navigation**
- **fzf integration** with ripgrep backend for lightning-fast file search
- **fzf-tab completion** providing zsh4humans-like interactive completion
- **Zoxide** for smart directory jumping
- **Advanced git status** in prompt with sync indicators

### 📁 **Smart File Management**
- **Ripgrep** for content search with hidden file support
- **fd** for fast directory traversal
- **eza** as a modern ls replacement

### 🎨 **Custom Prompt**
- **Git integration** with branch, staged/unstaged changes, and sync status
- **Path shortening** for long directory names
- **Exit code display** for failed commands
- **Clean, informative design**

## Installation

### Prerequisites
- **Zsh** 4.3.11 or later
- **Git** for cloning repositories
- **Recommended tools**: `ripgrep`, `fd`, `eza`, `fzf`, `zoxide`, `thefuck`

### Setup

1. **Clone this repository:**
   ```bash
   git clone --recursive https://github.com/seajupiter/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
   ```

2. **Install contrib modules:**
   ```bash
   cd "${ZDOTDIR:-$HOME}/.zprezto"
   ./setup.sh setup
   ```

3. **Link configuration files:**
   ```bash
   setopt EXTENDED_GLOB
   for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
     ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
   done
   ```

4. **Set Zsh as default shell:**
   ```bash
   chsh -s /bin/zsh
   ```

5. **Open a new terminal window**

## Contrib Module Management

This configuration includes a powerful script for managing external Zsh plugins and themes.

### Setup Script Usage

```bash
# Install all defined modules
./setup.sh setup

# Update all modules
./setup.sh update

# Update specific module
./setup.sh update fzf-tab

# List installed modules
./setup.sh list

# Remove a module
./setup.sh remove fzf-tab

# Show help
./setup.sh help
```

### Currently Configured Modules

- **[fzf-tab][12]** - Replace zsh's default completion selection menu with fzf

### Adding New Modules

Edit `setup.sh` and add new modules to the `CONTRIB_MODULES` array:

```bash
CONTRIB_MODULES=(
  "fzf-tab" "https://github.com/Aloxaf/fzf-tab.git"
  "zsh-you-should-use" "https://github.com/MichaelAquilina/zsh-you-should-use.git"
  "powerlevel10k" "https://github.com/romkatv/powerlevel10k.git"
)
```

Then run `./setup.sh setup` to install the new modules.

**Note:** Contrib modules are installed to `~/.zprezto/contrib/` and are automatically ignored by git.

## Key Bindings & Aliases

### Navigation
- `z <path>` - Smart directory jumping (zoxide)
- `zi` - Interactive directory selection (zoxide)
- `up` - Go up one directory (`cd ..`)

### File Operations
- `ls`, `ll`, `la` - Enhanced listing with eza
- `v` - Vim
- `e` - Emacs client (terminal)
- `ec` - Emacs client (GUI)

### Git Shortcuts
- `gt` - Git status
- `gaa` - Git add all

### System
- `rz` - Restart zsh (`exec zsh`)
- `fuck` - TheFuck correction (lazy loaded)
- `manp <cmd>` - Open man page in Skim PDF viewer

### fzf Integration
- `Ctrl+T` - File search with ripgrep
- `Ctrl+R` - Command history search
- `Alt+C` - Directory search with fd
- `**<TAB>` - fzf completion trigger

## Customization

### Prompt Customization
The prompt includes:
- Exit code display for failed commands
- Shortened paths for long directories (configurable length)
- Git branch with staging/unstaging indicators
- Upstream sync status (ahead/behind)
- Untracked files indicator

### Adding Lazy Loading
Follow the pattern used for zoxide and thefuck:

```bash
if command -v <tool> &> /dev/null; then
    <alias>() {
        unfunction <alias>
        eval "$(<tool> init zsh)"
        <alias> "$@"
    }
else
    <alias>() { echo "<tool> not installed" }
fi
```

## Updating

### Update Prezto Core
```bash
cd $ZPREZTODIR
git pull
git submodule sync --recursive
git submodule update --init --recursive
```

### Update Contrib Modules
```bash
./setup.sh update
```

## Performance Notes

- **Startup time**: ~200-300ms on modern hardware
- **Lazy loading**: Tools load only when first used
- **Completion caching**: Speeds up tab completion significantly
- **Optimized git status**: Minimal performance impact in large repos

## Troubleshooting

### Missing Commands
If commands are not found after setup, check `PATH` in `~/.zprofile`.

### Slow Startup
1. Check if any non-lazy loaded tools are causing delays
2. Verify completion cache is working (`ls ~/.zcompdump*`)
3. Consider moving more tools to lazy loading

### Git Status Issues
The custom git prompt hooks are optimized but can be disabled if needed:
```bash
zstyle ':vcs_info:git+set-message:*' hooks  # Remove git-untracked git-sync
```

## Dependencies

### Required
- `git` - Version control
- `zsh` - Shell (4.3.11+)

### Optional (Enhanced Experience)
- `ripgrep` - Fast content search
- `fd` - Fast file/directory search  
- `eza` - Modern ls replacement
- `fzf` - Fuzzy finder
- `zoxide` - Smart directory jumping
- `thefuck` - Command correction
- `vim` - Text editor

Install on macOS with Homebrew:
```bash
brew install ripgrep fd eza fzf zoxide thefuck vim
```

## License

This project is licensed under the MIT License.

[1]: https://github.com/sorin-ionescu/prezto
[12]: https://github.com/Aloxaf/fzf-tab
