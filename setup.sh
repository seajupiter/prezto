#!/usr/bin/env zsh

#
# Prezto Contrib Module Setup Script
#
# This script manages contrib modules for Prezto by automatically cloning
# missing repositories and providing update functionality.
#

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
info() { echo -e "${BLUE}ℹ${NC} $1" }
success() { echo -e "${GREEN}✓${NC} $1" }
warning() { echo -e "${YELLOW}⚠${NC} $1" }
error() { echo -e "${RED}✗${NC} $1" >&2 }

# Auto-clone missing contrib modules
ensure_contrib_module() {
  local module_name="$1"
  local repo_url="$2"
  local contrib_dir="${ZDOTDIR:-$HOME}/.zprezto/contrib"
  local module_path="$contrib_dir/$module_name"
  
  # Create contrib directory if it doesn't exist
  [[ ! -d "$contrib_dir" ]] && mkdir -p "$contrib_dir"
  
  # Clone module if it doesn't exist
  if [[ ! -d "$module_path" ]]; then
    info "Missing contrib module '$module_name', cloning from $repo_url..."
    if command -v git &>/dev/null; then
      if git clone "$repo_url" "$module_path"; then
        success "Successfully cloned $module_name"
      else
        error "Failed to clone $module_name from $repo_url"
        return 1
      fi
    else
      error "Git not found, cannot clone $module_name"
      return 1
    fi
  else
    info "$module_name already exists, skipping clone"
  fi
  return 0
}

# Update contrib module function
update_contrib_module() {
  local module_name="$1"
  local contrib_dir="${ZDOTDIR:-$HOME}/.zprezto/contrib"
  local module_path="$contrib_dir/$module_name"
  
  if [[ -d "$module_path/.git" ]]; then
    info "Updating $module_name..."
    if (cd "$module_path" && git pull); then
      success "Updated $module_name"
    else
      error "Failed to update $module_name"
      return 1
    fi
  else
    warning "$module_name is not a git repository, skipping update"
  fi
}

# Update all contrib modules function
update_all_contrib() {
  local contrib_dir="${ZDOTDIR:-$HOME}/.zprezto/contrib"
  if [[ -d "$contrib_dir" ]]; then
    info "Updating all contrib modules..."
    for module_dir in "$contrib_dir"/*(/); do
      [[ -d "$module_dir" ]] && update_contrib_module "${module_dir:t}"
    done
  else
    warning "No contrib directory found"
  fi
}

# List all contrib modules
list_contrib_modules() {
  local contrib_dir="${ZDOTDIR:-$HOME}/.zprezto/contrib"
  if [[ -d "$contrib_dir" ]]; then
    info "Installed contrib modules:"
    for module_dir in "$contrib_dir"/*(/); do
      if [[ -d "$module_dir" ]]; then
        local module_name="${module_dir:t}"
        local git_status=""
        if [[ -d "$module_dir/.git" ]]; then
          git_status=" (git repo)"
        fi
        echo "  • $module_name$git_status"
      fi
    done
  else
    warning "No contrib directory found"
  fi
}

# Remove a contrib module
remove_contrib_module() {
  local module_name="$1"
  local contrib_dir="${ZDOTDIR:-$HOME}/.zprezto/contrib"
  local module_path="$contrib_dir/$module_name"
  
  if [[ -d "$module_path" ]]; then
    read -q "REPLY?Remove module '$module_name'? (y/N) "
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      rm -rf "$module_path"
      success "Removed $module_name"
    else
      info "Cancelled removal of $module_name"
    fi
  else
    error "Module '$module_name' not found"
  fi
}

# Define contrib modules and their repositories
typeset -A CONTRIB_MODULES
CONTRIB_MODULES=(
  "fzf-tab" "https://github.com/Aloxaf/fzf-tab.git"
  # Add more modules here as needed:
  # "zsh-you-should-use" "https://github.com/MichaelAquilina/zsh-you-should-use.git"
  # "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions.git"
  # "powerlevel10k" "https://github.com/romkatv/powerlevel10k.git"
)

# Main setup function
setup_all_modules() {
  info "Setting up Prezto contrib modules..."
  local failed_modules=()
  
  for module_name repo_url in ${(kv)CONTRIB_MODULES}; do
    if ! ensure_contrib_module "$module_name" "$repo_url"; then
      failed_modules+=("$module_name")
    fi
  done
  
  if [[ ${#failed_modules[@]} -eq 0 ]]; then
    success "All contrib modules are ready!"
  else
    error "Failed to setup: ${failed_modules[*]}"
    return 1
  fi
}

# Print usage information
usage() {
  cat << EOF
Prezto Contrib Module Setup Script

Usage: ${0:t} [COMMAND] [OPTIONS]

Commands:
  setup, install    Install all defined contrib modules
  update [MODULE]   Update a specific module or all modules
  list, ls          List all installed contrib modules
  remove MODULE     Remove a contrib module
  help              Show this help message

Examples:
  ${0:t} setup                    # Install all modules
  ${0:t} update                   # Update all modules
  ${0:t} update fzf-tab          # Update specific module
  ${0:t} remove fzf-tab          # Remove specific module
  ${0:t} list                    # List installed modules

Defined modules:
EOF
  for module_name repo_url in ${(kv)CONTRIB_MODULES}; do
    echo "  • $module_name: $repo_url"
  done
}

# Main script logic
main() {
  local command="${1:-setup}"
  
  case "$command" in
    setup|install)
      setup_all_modules
      ;;
    update)
      if [[ -n "$2" ]]; then
        update_contrib_module "$2"
      else
        update_all_contrib
      fi
      ;;
    list|ls)
      list_contrib_modules
      ;;
    remove|rm)
      if [[ -n "$2" ]]; then
        remove_contrib_module "$2"
      else
        error "Please specify a module name to remove"
        exit 1
      fi
      ;;
    help|--help|-h)
      usage
      ;;
    *)
      error "Unknown command: $command"
      usage
      exit 1
      ;;
  esac
}

# Run main function with all arguments
main "$@"
