# Idea Factory

File-based infrastructure for persistent AI conversations. Optimizes for getting from idea to production in a single prompt.

## What This Is

A system for working on many ideas simultaneously without losing context. When you say "continue" in a new session, full context restores: decisions made, assumptions tested, readiness score, what to do next.

The objective function: **minimize prompts from idea to production**.

## The Problem

Traditional AI development loses context between sessions. You have a productive conversation, close your laptop, come back tomorrow—context is gone. You spend the first 10 minutes reconstructing what you already discussed.

This compounds when working on multiple ideas. Context switching between projects means starting from zero each time.

**Result:** You can only work on 2-3 ideas because the context tax is too high.

## How It Works

### File-Based Persistence

```
project/
  .claude/
    conversations/        # Daily logs
    insights/            # Extracted decisions, assumptions, blockers
    state/
      session.json       # Last session summary
      readiness.json     # 0-100 score
      next.md           # Queued actions

  .idea-factory/
    working-guide.md     # Methodology
    conversation-protocol.md
```

When you say "continue", Claude reads these files and reconstructs full context.

### Insight Extraction

Conversations automatically extract:
- **Decisions** - "Let's use PostgreSQL"
- **Assumptions** - "Users will want email notifications"
- **Blockers** - "Don't know how to handle edge case X"
- **Approaches** - "Implement with queue-based architecture"

These accumulate in structured JSON, queryable across all projects.

### Readiness Tracking

Don't build until you have a clear prompt. Readiness score (0-100%) indicates when:

```
readiness = (
  coreValue      * 0.30 +    // Problem clarity
  mvpScope       * 0.25 +    // What to build
  techApproach   * 0.25 +    // How to build
  assumptions    * 0.10 +    // Validated?
  blockers       * 0.10      // Resolved?
)
```

- **0-40%:** Keep talking, don't code
- **40-70%:** Getting clearer
- **70%+:** Clear prompt, start building

### Cross-Project Learning

Insights compound across projects:

```bash
# All ideas using email parsing
grep "email parsing" ~/.ideafactory/catalog/catalog.csv

# All assumptions that failed
jq '.assumptions[] | select(.validated == false)' */.claude/insights/all.json

# Patterns that worked in shipped projects
find . -name "readiness.json" -exec jq 'select(.score > 85)' {} \;
```

Learnings from project 1 inform approach on project 50.

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/pauljump/idea-factory/main/install.sh | bash
```

Requires: `git`, `gh` (GitHub CLI)

## Usage

### Create Project

```bash
if-setup my-idea
cd my-idea
```

Opens with `.claude/` and `.idea-factory/` scaffolded, GitHub repo created.

### Start Conversation

In Claude Code:

```
User: continue

Claude: Welcome to my-idea.

This is a new project. Let's define:
- Core problem
- Primary user
- Value proposition

What should we work on?
```

### Resume Later

Close laptop. Come back days later:

```
User: continue

Claude: Welcome back to my-idea.

Last session: 8 days ago
Readiness: 72% (ready to build)

Decisions made:
✓ Use X for Y
✓ Approach Z for core logic
✓ Start with minimal scope

Assumptions to validate:
⚠ Users will adopt this workflow
⚠ Technical approach handles edge cases

Next: Build first prototype

What should we work on?
```

Full context restored.

### Work on Multiple Ideas

```bash
if-setup project-a
if-setup project-b
if-setup project-c

cd project-a    # Say "continue" → context A
cd project-b    # Say "continue" → context B
cd project-c    # Say "continue" → context C
```

Each maintains independent context. Switch freely.

### View All Projects

```bash
if-analytics
```

```
┌─────────────────────────────────────────────┐
│  project-a          █████████░ 85% ✓ READY  │
│  project-b          ██████░░░░ 58% ⚡ WIP   │
│  project-c          ████░░░░░░ 42% 💭 THINK │
└─────────────────────────────────────────────┘
```

### Sync Methodology

Edit methodology once, deploy to all projects:

```bash
# Edit the master template
open ~/.ideafactory/templates/.idea-factory/working-guide.md

# Deploy to all projects
if-sync
```

## Why This Works

**Conversation persistence** - Context survives session closure
**Structured insights** - Decisions/assumptions/blockers extracted automatically
**Readiness scoring** - Don't build until prompt is clear
**Cross-project learning** - Insights from 150 projects compound
**Methodology as code** - Templates sync globally

**Result:** Work on 150 ideas with same cognitive overhead as 3.

## Architecture

Pure bash. No npm, no Python, no dependencies beyond git/gh.

**Core libraries:**
- `lib/utils.sh` - Common functions
- `lib/config.sh` - Configuration
- `lib/scaffold.sh` - Project setup

**Commands:**
- `if-setup` - Create project
- `if-sync` - Sync templates
- `if-analytics` - View readiness

**Templates:**
- `.claude/` - Conversation persistence structure
- `.idea-factory/` - Methodology templates

## Commands

```bash
if-setup <name>       # Create new project
if-sync               # Sync methodology to all projects
if-analytics          # View readiness dashboard
```

## Configuration

Edit `~/.ideafactory/config` to change defaults:

```bash
PROJECTS_DIR=$HOME/Desktop/projects
TEMPLATES_DIR=$HOME/.ideafactory/templates
CATALOG_DIR=$HOME/.ideafactory/catalog
```

## GitHub Integration

Every project gets a GitHub repo. Use issues as external memory:

```bash
gh issue create --title "Try approach X"
```

Next session, Claude sees the issue and incorporates it.

## Scale

Tested with 150+ projects. No practical limit. Readiness dashboard shows all at once.

## Examples

See `docs/getting-started.md` for walkthrough.

## License

MIT

## Links

- [Getting Started](docs/getting-started.md)
- [GitHub](https://github.com/pauljump/idea-factory)
- [Issues](https://github.com/pauljump/idea-factory/issues)
