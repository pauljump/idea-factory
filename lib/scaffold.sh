#!/bin/bash

# Idea Factory - Scaffolding Library
# Core logic for creating AI-ready workspaces

# Scaffold a new project from scratch
scaffold_new_project() {
    local project_name="$1"
    local project_path="$(get_projects_dir)/$project_name"

    log_info "Scaffolding: $project_name"
    echo ""

    # Create project directory
    if [ -d "$project_path" ]; then
        log_warning "Directory already exists: $project_path"
        if ! confirm "Continue anyway?"; then
            exit 0
        fi
    else
        mkdir -p "$project_path"
        log_success "Created $project_path"
    fi

    cd "$project_path"

    # Initialize .claude/ structure
    init_claude_structure "$project_name"

    # Copy .idea-factory/ templates
    copy_idea_factory_templates

    # Create idea-context.json
    create_idea_context "$project_name" "" "concept"

    # Create experiments directory
    mkdir -p experiments
    log_success "Created experiments/"

    # Generate README
    generate_readme "$project_name" "AI-powered project" "concept"

    # Git init
    init_git_repo "$project_name"

    # Create GitHub repo
    create_github_repo "$project_name" "AI-powered project"

    log_success "Project scaffolded at $project_path"
}

# Scaffold from catalog entry
scaffold_from_catalog() {
    local idea_id="$1"
    local project_name="${2:-}"
    local catalog_file="$(get_catalog_dir)/catalog.csv"

    if [ ! -f "$catalog_file" ]; then
        die "Catalog not found: $catalog_file"
    fi

    # Find idea in catalog
    local idea_row=$(grep "^$idea_id," "$catalog_file")
    if [ -z "$idea_row" ]; then
        die "Idea $idea_id not found in catalog"
    fi

    # Parse catalog fields
    local title=$(parse_csv_field "$idea_row" 4)
    local status=$(parse_csv_field "$idea_row" 6)
    local one_liner=$(parse_csv_field "$idea_row" 7)
    local catalog_dir=$(parse_csv_field "$idea_row" 3)

    # Use provided name or catalog name or sanitized title
    if [ -z "$project_name" ]; then
        if [ -n "$catalog_dir" ] && [ "$catalog_dir" != "UNKNOWN" ]; then
            project_name="$catalog_dir"
        else
            project_name=$(sanitize_filename "$title")
        fi
    fi

    local project_path="$(get_projects_dir)/$project_name"

    log_info "Scaffolding from catalog: $idea_id"
    log_info "Title: $title"
    log_info "Status: $status"
    echo ""

    # Create project directory
    if [ -d "$project_path" ]; then
        log_warning "Directory already exists: $project_path"
    else
        mkdir -p "$project_path"
        log_success "Created $project_path"
    fi

    cd "$project_path"

    # Initialize structures
    init_claude_structure "$project_name"
    copy_idea_factory_templates
    create_idea_context "$project_name" "$idea_id" "$status"

    # Copy idea card if exists
    copy_idea_card "$idea_id"

    mkdir -p experiments
    log_success "Created experiments/"

    # Generate README
    generate_readme "$project_name" "$one_liner" "$status"

    # Git init
    init_git_repo "$project_name" "$idea_id"

    # Create GitHub repo
    create_github_repo "$project_name" "$one_liner"

    # Create GitHub issues from idea card
    create_github_issues_from_card "$idea_id"

    log_success "Project scaffolded from $idea_id"
}

# Initialize .claude/ directory structure
init_claude_structure() {
    local project_name="$1"

    log_info "Initializing .claude/ structure..."

    mkdir -p .claude/{conversations,insights,signals,state}

    # Create empty files
    touch .claude/signals/inbox.md
    echo "[]" > .claude/insights/all.json

    # Create initial state files
    cat > .claude/state/session.json << EOF
{
  "project": "$project_name",
  "lastActive": "$(timestamp)",
  "summary": "Initial setup",
  "sessionsCount": 0
}
EOF

    cat > .claude/state/readiness.json << EOF
{
  "score": 0,
  "breakdown": {
    "coreValue": 0,
    "mvpScope": 0,
    "technicalApproach": 0,
    "assumptions": 0,
    "blockers": 0
  },
  "status": "exploring",
  "blockers": [],
  "nextActions": ["Start conversation to define project"],
  "lastUpdated": "$(timestamp)"
}
EOF

    echo "# Next Steps" > .claude/state/next.md
    echo "" >> .claude/state/next.md
    echo "- [ ] Define core problem" >> .claude/state/next.md
    echo "- [ ] Identify primary user" >> .claude/state/next.md
    echo "- [ ] Clarify value proposition" >> .claude/state/next.md

    cat > .claude/.clauignore << EOF
# Idea Factory .clauignore
# Don't log these files/directories

.git
node_modules
.env
.env.*
*.key
*.pem
credentials.json
EOF

    log_success "Created .claude/ structure"
}

# Copy .idea-factory/ templates
copy_idea_factory_templates() {
    log_info "Copying .idea-factory/ templates..."

    local templates_dir="$(get_templates_dir)/.idea-factory"

    if [ ! -d "$templates_dir" ]; then
        log_warning "Templates directory not found: $templates_dir"
        log_info "Creating minimal templates..."
        mkdir -p .idea-factory
        echo "# Working Guide" > .idea-factory/working-guide.md
        return
    fi

    rm -rf .idea-factory
    mkdir -p .idea-factory

    # Copy all templates except idea-context.json
    for file in "$templates_dir"/*; do
        if [[ $(basename "$file") != "idea-context.json"* ]]; then
            cp "$file" .idea-factory/
        fi
    done

    log_success "Copied .idea-factory/ templates"
}

# Create idea-context.json
create_idea_context() {
    local project_name="$1"
    local idea_id="${2:-}"
    local status="${3:-concept}"

    cat > .idea-factory/idea-context.json << EOF
{
  "ideaId": "${idea_id}",
  "title": "$project_name",
  "status": "$status",
  "readiness": 0,
  "github": "",
  "directory": "$project_name",
  "relatedIdeas": [],
  "lastSession": "$(timestamp)",
  "technology": [],
  "domain": [],
  "nextMilestone": "Start conversation to define project",
  "notes": ""
}
EOF

    log_success "Created idea-context.json"
}

# Copy idea card from catalog
copy_idea_card() {
    local idea_id="$1"
    local cards_dir="$(get_catalog_dir)/cards"
    local card_file=$(find "$cards_dir" -name "${idea_id}*.md" 2>/dev/null | head -1)

    if [ -n "$card_file" ] && [ -f "$card_file" ]; then
        cp "$card_file" IDEA-CARD.md
        log_success "Copied idea card"
    else
        log_info "No idea card found (optional)"
    fi
}

# Generate README
generate_readme() {
    local project_name="$1"
    local one_liner="${2:-AI-powered project}"
    local status="${3:-concept}"

    cat > README.md << EOF
# $project_name

**Status:** $status

$one_liner

## Quick Links

- [Working Guide](./.idea-factory/working-guide.md)
- [GitHub Integration](./.idea-factory/github-integration.md)
- [Conversation Protocol](./.idea-factory/conversation-protocol.md)

## Status

**Readiness:** 0% (exploring)

See [\`.claude/state/readiness.json\`](./.claude/state/readiness.json) for breakdown.

## Getting Started

\`\`\`bash
cd $PWD
# Open Claude Code and say "continue"
\`\`\`

## Next Steps

See [\`.claude/state/next.md\`](./.claude/state/next.md)

---

🤖 Generated with [Idea Factory](https://github.com/pauljump/idea-factory)
EOF

    log_success "Generated README.md"
}

# Initialize git repository
init_git_repo() {
    local project_name="$1"
    local idea_id="${2:-}"

    if is_git_repo "."; then
        log_info "Git repo already exists"
        return
    fi

    log_info "Initializing git repository..."

    git init -q

    # Create .gitignore
    cat > .gitignore << 'EOF'
# Idea Factory
.env
.env.*
*.key
*.pem
credentials.json

# Node
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Python
__pycache__/
*.py[cod]
*$py.class
.venv/
venv/

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db
EOF

    git add .
    git commit -q -m "Initial commit: Idea Factory scaffold

Generated with idea-factory
${idea_id:+Idea ID: $idea_id}

Infrastructure:
- .claude/ conversation persistence
- .idea-factory/ methodology templates
- GitHub integration ready"

    log_success "Initialized git repository"
}

# Create GitHub repository
create_github_repo() {
    local project_name="$1"
    local description="${2:-AI-powered project}"
    local github_user=$(get_github_user)

    if [ -z "$github_user" ]; then
        log_warning "GitHub CLI not authenticated, skipping repo creation"
        log_info "You can create it later with: gh repo create"
        return
    fi

    log_info "Creating GitHub repository..."

    # Check if repo already exists
    if github_repo_exists "$github_user/$project_name"; then
        log_info "GitHub repo already exists: $github_user/$project_name"
        return
    fi

    # Create repo
    if gh repo create "$github_user/$project_name" \
        --public \
        --source=. \
        --description="$description" \
        --push &> /dev/null; then

        log_success "Created GitHub repo: $github_user/$project_name"

        # Update idea-context.json with GitHub URL
        if [ -f ".idea-factory/idea-context.json" ]; then
            local github_url="https://github.com/$github_user/$project_name"
            # Update github field (macOS/Linux compatible)
            if command -v jq &> /dev/null; then
                jq ".github = \"$github_url\"" .idea-factory/idea-context.json > .idea-factory/idea-context.json.tmp
                mv .idea-factory/idea-context.json.tmp .idea-factory/idea-context.json
            fi
        fi
    else
        log_warning "Failed to create GitHub repo (may need authentication)"
        log_info "Create manually with: gh repo create"
    fi
}

# Create GitHub issues from idea card
create_github_issues_from_card() {
    local idea_id="$1"

    if [ ! -f "IDEA-CARD.md" ]; then
        log_info "No idea card, skipping issue creation"
        return
    fi

    log_info "Creating GitHub issues from open questions..."

    # Extract open questions section
    local questions=$(sed -n '/## Open questions/,/## /p' IDEA-CARD.md | grep "^[0-9]" | sed 's/^[0-9]*\. //')

    if [ -z "$questions" ]; then
        log_info "No open questions found"
        return
    fi

    local count=0
    while IFS= read -r question; do
        if [ -n "$question" ]; then
            if gh issue create \
                --title "$question" \
                --label "question" \
                --body "Open question from $idea_id idea card.

This needs to be answered during exploration phase." &> /dev/null; then
                ((count++))
            fi
        fi
    done <<< "$questions"

    if [ $count -gt 0 ]; then
        log_success "Created $count GitHub issues from open questions"
    fi
}

# Export functions
export -f scaffold_new_project scaffold_from_catalog
export -f init_claude_structure copy_idea_factory_templates
export -f create_idea_context copy_idea_card generate_readme
export -f init_git_repo create_github_repo create_github_issues_from_card
