#!/bin/bash

# Idea Factory - Configuration Management
# Load and manage configuration

# Default config path
DEFAULT_CONFIG_DIR="$HOME/.ideafactory"
CONFIG_FILE="$DEFAULT_CONFIG_DIR/config"

# Default values
DEFAULT_PROJECTS_DIR="$HOME/Desktop/projects"
DEFAULT_TEMPLATES_DIR="$DEFAULT_CONFIG_DIR/templates"
DEFAULT_CATALOG_DIR="$DEFAULT_CONFIG_DIR/catalog"
DEFAULT_GITHUB_ORG=""

# Load config
load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
    fi

    # Set defaults if not in config
    PROJECTS_DIR="${PROJECTS_DIR:-$DEFAULT_PROJECTS_DIR}"
    TEMPLATES_DIR="${TEMPLATES_DIR:-$DEFAULT_TEMPLATES_DIR}"
    CATALOG_DIR="${CATALOG_DIR:-$DEFAULT_CATALOG_DIR}"
    GITHUB_ORG="${GITHUB_ORG:-$DEFAULT_GITHUB_ORG}"
}

# Get config value
get_config() {
    local key="$1"
    load_config
    eval echo "\$$key"
}

# Set config value
set_config() {
    local key="$1"
    local value="$2"

    # Create config if doesn't exist
    if [ ! -f "$CONFIG_FILE" ]; then
        mkdir -p "$DEFAULT_CONFIG_DIR"
        cat > "$CONFIG_FILE" << EOF
# Idea Factory Configuration
VERSION=1.0.0
PROJECTS_DIR=$DEFAULT_PROJECTS_DIR
TEMPLATES_DIR=$DEFAULT_TEMPLATES_DIR
CATALOG_DIR=$DEFAULT_CATALOG_DIR
GITHUB_ORG=$DEFAULT_GITHUB_ORG
EOF
    fi

    # Update or add key
    if grep -q "^${key}=" "$CONFIG_FILE"; then
        # macOS compatible sed
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s|^${key}=.*|${key}=${value}|" "$CONFIG_FILE"
        else
            sed -i "s|^${key}=.*|${key}=${value}|" "$CONFIG_FILE"
        fi
    else
        echo "${key}=${value}" >> "$CONFIG_FILE"
    fi
}

# Getters for common config
get_projects_dir() {
    get_config "PROJECTS_DIR"
}

get_templates_dir() {
    get_config "TEMPLATES_DIR"
}

get_catalog_dir() {
    get_config "CATALOG_DIR"
}

get_github_org() {
    get_config "GITHUB_ORG"
}

# Initialize (load config on source)
load_config
