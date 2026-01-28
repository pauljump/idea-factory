#!/bin/bash
set -e

# Idea Factory Installer
# One-line install: curl -fsSL https://raw.githubusercontent.com/pauljump/idea-factory/main/install.sh | bash

VERSION="1.0.0"
INSTALL_DIR="$HOME/.ideafactory"
BIN_DIR="$HOME/.local/bin"
REPO_URL="https://github.com/pauljump/idea-factory"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo_color() {
    color=$1
    shift
    echo -e "${color}$@${NC}"
}

echo ""
echo_color "$BLUE" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo_color "$BLUE" "  Idea Factory Installer v${VERSION}"
echo_color "$BLUE" "  Persistent context for AI-native development"
echo_color "$BLUE" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macOS"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="Linux"
else
    echo_color "$RED" "❌ Unsupported OS: $OSTYPE"
    echo "   Idea Factory currently supports macOS and Linux"
    echo "   Windows support coming soon via WSL2"
    exit 1
fi

echo_color "$GREEN" "✓ Detected OS: $OS"

# Check dependencies
echo ""
echo "Checking dependencies..."

check_dependency() {
    if command -v $1 &> /dev/null; then
        echo_color "$GREEN" "  ✓ $1"
        return 0
    else
        echo_color "$RED" "  ✗ $1"
        return 1
    fi
}

DEPS_OK=true

if ! check_dependency git; then
    DEPS_OK=false
    echo_color "$YELLOW" "    Install git: https://git-scm.com/downloads"
fi

if ! check_dependency gh; then
    DEPS_OK=false
    echo_color "$YELLOW" "    Install GitHub CLI: https://cli.github.com/"
    echo_color "$YELLOW" "    macOS: brew install gh"
    echo_color "$YELLOW" "    Linux: https://github.com/cli/cli/blob/trunk/docs/install_linux.md"
fi

if [ "$DEPS_OK" = false ]; then
    echo ""
    echo_color "$RED" "❌ Missing required dependencies"
    echo "   Please install the above tools and run this installer again"
    exit 1
fi

# Check GitHub auth
echo ""
echo "Checking GitHub authentication..."
if gh auth status &> /dev/null; then
    echo_color "$GREEN" "  ✓ GitHub CLI authenticated"
else
    echo_color "$YELLOW" "  ⚠ GitHub CLI not authenticated"
    echo ""
    read -p "  Authenticate now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        gh auth login
    else
        echo_color "$YELLOW" "  You can authenticate later with: gh auth login"
    fi
fi

# Create directories
echo ""
echo "Creating directories..."
mkdir -p "$INSTALL_DIR"/{bin,lib,templates/{.claude,.idea-factory},examples,docs}
mkdir -p "$BIN_DIR"
echo_color "$GREEN" "  ✓ Created $INSTALL_DIR"

# Clone or update repo
echo ""
if [ -d "$INSTALL_DIR/.git" ]; then
    echo "Updating Idea Factory..."
    cd "$INSTALL_DIR"
    git pull origin main &> /dev/null
    echo_color "$GREEN" "  ✓ Updated to latest version"
else
    echo "Downloading Idea Factory..."
    git clone --quiet "$REPO_URL" "$INSTALL_DIR/tmp"

    # Move contents to install dir
    mv "$INSTALL_DIR/tmp"/* "$INSTALL_DIR/" 2>/dev/null || true
    mv "$INSTALL_DIR/tmp"/.* "$INSTALL_DIR/" 2>/dev/null || true
    rm -rf "$INSTALL_DIR/tmp"

    echo_color "$GREEN" "  ✓ Downloaded Idea Factory v${VERSION}"
fi

# Make scripts executable
chmod +x "$INSTALL_DIR/bin"/*
chmod +x "$INSTALL_DIR/lib"/*

# Create symlinks in PATH
echo ""
echo "Creating command symlinks..."
ln -sf "$INSTALL_DIR/bin/idea-factory" "$BIN_DIR/idea-factory"
ln -sf "$INSTALL_DIR/bin/if-setup" "$BIN_DIR/if-setup"
ln -sf "$INSTALL_DIR/bin/if-sync" "$BIN_DIR/if-sync"
ln -sf "$INSTALL_DIR/bin/if-analytics" "$BIN_DIR/if-analytics"

echo_color "$GREEN" "  ✓ if-setup"
echo_color "$GREEN" "  ✓ if-sync"
echo_color "$GREEN" "  ✓ if-analytics"

# Add to PATH if needed
echo ""
SHELL_RC=""
if [[ "$SHELL" == *"zsh"* ]]; then
    SHELL_RC="$HOME/.zshrc"
elif [[ "$SHELL" == *"bash"* ]]; then
    SHELL_RC="$HOME/.bashrc"
fi

if [ -n "$SHELL_RC" ]; then
    if ! grep -q "$BIN_DIR" "$SHELL_RC" 2>/dev/null; then
        echo "Adding to PATH in $SHELL_RC..."
        echo "" >> "$SHELL_RC"
        echo "# Idea Factory" >> "$SHELL_RC"
        echo "export PATH=\"$BIN_DIR:\$PATH\"" >> "$SHELL_RC"
        echo_color "$GREEN" "  ✓ Added to PATH"
        echo_color "$YELLOW" "  ⚠ Run: source $SHELL_RC"
    else
        echo_color "$GREEN" "  ✓ Already in PATH"
    fi
fi

# Create config
echo ""
echo "Creating configuration..."
cat > "$INSTALL_DIR/config" << EOF
# Idea Factory Configuration
VERSION=$VERSION
PROJECTS_DIR=$HOME/Desktop/projects
TEMPLATES_DIR=$INSTALL_DIR/templates
CATALOG_DIR=$INSTALL_DIR/catalog
GITHUB_ORG=
EOF

echo_color "$GREEN" "  ✓ Config created at $INSTALL_DIR/config"

# Create initial catalog
echo ""
echo "Creating catalog..."
mkdir -p "$INSTALL_DIR/catalog/cards"

if [ ! -f "$INSTALL_DIR/catalog/catalog.csv" ]; then
    cat > "$INSTALL_DIR/catalog/catalog.csv" << 'EOF'
id,collection,directory,title,type,status,one_liner,primary_user,buyer,value_prop,trigger,first_experience,aha_moment,ecosystem,competition,moats,unfair_advantage,acquisition,revenue_model,failure_scenario,open_questions,fastest_path_to_truth,related,technology,feasibility,resources_needed,timeline,personal_connection
EOF
    echo_color "$GREEN" "  ✓ Created empty catalog"
else
    echo_color "$YELLOW" "  ✓ Catalog already exists"
fi

# Success!
echo ""
echo_color "$GREEN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo_color "$GREEN" "  ✨ Idea Factory installed successfully!"
echo_color "$GREEN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Quick start:"
echo ""
echo_color "$BLUE" "  # Create your first idea"
echo "  if-setup my-first-idea"
echo ""
echo_color "$BLUE" "  # Open in Claude Code and say 'continue'"
echo "  cd my-first-idea"
echo ""
echo "Documentation:"
echo "  ${REPO_URL}#quick-start"
echo ""
echo "Commands:"
echo "  if-setup <name>    - Create AI-ready workspace"
echo "  if-sync            - Sync methodology to all projects"
echo "  if-analytics       - View project readiness dashboard"
echo ""

if [ -n "$SHELL_RC" ] && ! grep -q "$BIN_DIR" <<< "$PATH"; then
    echo_color "$YELLOW" "⚠️  Important: Run this to use commands immediately:"
    echo "  source $SHELL_RC"
    echo ""
fi

echo_color "$BLUE" "Happy building! 🚀"
echo ""
