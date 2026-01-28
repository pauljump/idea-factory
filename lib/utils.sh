#!/bin/bash

# Idea Factory - Utility Functions
# Common functions used across all scripts

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Logging functions
log() {
    echo -e "${GREEN}${1}${NC}"
}

log_info() {
    echo -e "${BLUE}ℹ  ${1}${NC}"
}

log_success() {
    echo -e "${GREEN}✓ ${1}${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠  ${1}${NC}"
}

log_error() {
    echo -e "${RED}✗ ${1}${NC}" >&2
}

log_header() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  ${1}${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

echo_blue() {
    echo -e "${BLUE}${1}${NC}"
}

echo_green() {
    echo -e "${GREEN}${1}${NC}"
}

echo_yellow() {
    echo -e "${YELLOW}${1}${NC}"
}

echo_red() {
    echo -e "${RED}${1}${NC}"
}

# Error handling
error() {
    log_error "$1"
}

die() {
    error "$1"
    exit 1
}

# Check if command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Check dependencies
check_dependencies() {
    local missing=()

    if ! command_exists git; then
        missing+=("git")
    fi

    if ! command_exists gh; then
        missing+=("gh (GitHub CLI)")
    fi

    if [ ${#missing[@]} -gt 0 ]; then
        error "Missing dependencies: ${missing[*]}"
        echo ""
        echo "Install:"
        echo "  git: https://git-scm.com/downloads"
        echo "  gh:  https://cli.github.com/"
        echo ""
        return 1
    fi

    return 0
}

# Check GitHub authentication
check_github_auth() {
    if ! gh auth status &> /dev/null; then
        log_warning "GitHub CLI not authenticated"
        echo ""
        read -p "Authenticate now? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            gh auth login
        else
            log_warning "Skipping GitHub authentication"
            log_info "You can authenticate later with: gh auth login"
            return 1
        fi
    fi
    return 0
}

# Generate timestamp
timestamp() {
    date -u +"%Y-%m-%dT%H:%M:%SZ"
}

# Generate date
today() {
    date +"%Y-%m-%d"
}

# Sanitize string for filename
sanitize_filename() {
    echo "$1" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | sed 's/[^a-z0-9-]//g'
}

# Create directory if not exists
ensure_dir() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
        log_success "Created $1"
    fi
}

# Progress spinner
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while ps -p $pid > /dev/null 2>&1; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Confirm action
confirm() {
    read -p "$1 (y/n) " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}

# Get user input with default
get_input() {
    local prompt="$1"
    local default="$2"
    local input

    if [ -n "$default" ]; then
        read -p "$prompt [$default]: " input
        echo "${input:-$default}"
    else
        read -p "$prompt: " input
        echo "$input"
    fi
}

# Parse CSV line (basic - doesn't handle quoted commas)
parse_csv_field() {
    local line="$1"
    local field_num="$2"
    echo "$line" | cut -d',' -f"$field_num"
}

# Check if directory is git repo
is_git_repo() {
    [ -d "$1/.git" ]
}

# Check if GitHub repo exists
github_repo_exists() {
    local repo="$1"
    gh repo view "$repo" &> /dev/null
}

# Get GitHub username
get_github_user() {
    gh api user --jq .login 2>/dev/null || echo ""
}

# Format readiness score
format_readiness() {
    local score=$1
    local bar_length=10
    local filled=$(( score * bar_length / 100 ))
    local empty=$(( bar_length - filled ))

    printf "["
    printf "%${filled}s" | tr ' ' '█'
    printf "%${empty}s" | tr ' ' '░'
    printf "] %3d%%" "$score"
}

# Format status with emoji
format_status() {
    local status="$1"
    case "$status" in
        concept)
            echo "💭 Concept"
            ;;
        building)
            echo "🔨 Building"
            ;;
        shipped)
            echo "🚀 Shipped"
            ;;
        abandoned)
            echo "💀 Abandoned"
            ;;
        *)
            echo "$status"
            ;;
    esac
}

# Print table row
table_row() {
    printf "│ %-20s │ %-15s │ %-15s │\n" "$1" "$2" "$3"
}

# Print table separator
table_sep() {
    printf "├──────────────────────┼─────────────────┼─────────────────┤\n"
}

# Export all functions
export -f log log_info log_success log_warning log_error log_header
export -f echo_blue echo_green echo_yellow echo_red
export -f error die
export -f command_exists check_dependencies check_github_auth
export -f timestamp today sanitize_filename ensure_dir
export -f spinner confirm get_input parse_csv_field
export -f is_git_repo github_repo_exists get_github_user
export -f format_readiness format_status table_row table_sep
