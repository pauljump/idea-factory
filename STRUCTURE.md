# Idea Factory - Production Structure

```
idea-factory/
├── README.md                      # Killer landing page
├── LICENSE                        # MIT
├── CONTRIBUTING.md
├── install.sh                     # curl -fsSL ... | bash
├── uninstall.sh
│
├── bin/                           # Main executables
│   ├── idea-factory              # Main CLI
│   ├── if-setup                  # setup-idea → if-setup (branded)
│   ├── if-sync                   # sync-templates → if-sync
│   └── if-analytics              # Dashboard launcher
│
├── lib/                           # Core logic (sourced by bin/)
│   ├── catalog.sh                # Catalog management
│   ├── scaffold.sh               # Project scaffolding
│   ├── github.sh                 # GitHub integration
│   ├── templates.sh              # Template syncing
│   ├── analytics.sh              # Readiness tracking
│   └── utils.sh                  # Common functions
│
├── templates/                     # Master templates
│   ├── .claude/
│   │   └── PROTOCOL.md
│   └── .idea-factory/
│       ├── conversation-protocol.md
│       ├── working-guide.md
│       ├── experiment-template.md
│       ├── github-integration.md
│       ├── questions-tracker.json
│       └── idea-context.json.template
│
├── examples/                      # Pre-built examples
│   ├── 001-minimal-idea/         # 5-minute tutorial
│   ├── 002-saas-product/         # Full example
│   └── TUTORIAL.md
│
├── docs/                          # Comprehensive docs
│   ├── getting-started.md
│   ├── core-concepts.md
│   ├── commands.md
│   ├── readiness-system.md
│   ├── github-integration.md
│   ├── advanced-usage.md
│   └── troubleshooting.md
│
├── tests/                         # Automated tests
│   ├── test-install.sh
│   ├── test-scaffold.sh
│   └── test-integration.sh
│
├── .github/
│   ├── workflows/
│   │   ├── test.yml              # CI on push
│   │   └── release.yml           # Auto-release
│   └── ISSUE_TEMPLATE.md
│
└── website/                       # Landing page (optional but 🔥)
    ├── index.html
    ├── demo.gif
    └── assets/
```

## Key Improvements Over Current

### 1. Installation
**Current:** Manual setup
**Production:** `curl -fsSL https://ideafactory.sh/install | bash`

### 2. CLI Branding
**Current:** `setup-idea`, `sync-templates`
**Production:** `if-setup`, `if-sync`, `if-analytics`

### 3. Error Handling
**Current:** Basic `set -e`
**Production:** Detailed error messages, recovery suggestions

### 4. Configuration
**Current:** Hardcoded paths
**Production:** `~/.ideafactory/config` with overrides

### 5. Analytics Dashboard
**Current:** JSON files
**Production:** Terminal UI (like htop) showing all 150 projects

### 6. Documentation
**Current:** One massive COMPLETE_SYSTEM_REFERENCE.md
**Production:** Modular docs + interactive tutorial

### 7. Community
**Current:** Personal tool
**Production:** Contributing guide, issue templates, examples
