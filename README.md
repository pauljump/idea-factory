# Idea Factory

**Persistent context for AI-native development. Work on 150 ideas without chaos.**

<div align="center">

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey)

[Quick Start](#quick-start) • [Documentation](docs/getting-started.md) • [Examples](examples/) • [Why This Exists](#why-this-exists)

</div>

---

## The Problem

You're building something with Claude. Making progress. Then you close your laptop.

Next day: **New conversation. Context gone. Start over.**

This is why people don't ship with AI.

## The Solution

```bash
# One-time install
curl -fsSL https://raw.githubusercontent.com/pauljump/idea-factory/main/install.sh | bash

# Setup any idea
if-setup my-saas-idea

# Every session after
cd my-saas-idea
```

Say: **"continue"**

```
Welcome back to my-saas-idea.

Last session: 8 days ago
Readiness: 72% (ready to build!)

Decisions made:
✅ Use PostgreSQL for storage
✅ Stripe for payments
✅ Next.js for frontend

Open questions:
⚠️ How to handle auth?

Next: Test OAuth flow

What should we work on?
```

**Everything is still there.**

---

## What You Get

### 🧠 Persistent Context
- Conversations survive session closure
- Decisions automatically extracted
- Readiness tracked continuously
- Never lose context again

### 🎯 Portfolio Creativity
- Work on **150 ideas** (not just 1-3)
- Context switches **instantly**
- Ideas compound across projects

### 📈 Readiness-Driven Development
- **0-40%:** Exploring (keep talking)
- **40-70%:** Designing (getting clearer)
- **70%+:** Ready to build (perfect prompt achieved)

### 🔄 Methodology as Code
- Templates sync globally
- Improve once, deploy everywhere
- Methodology compounds over time

---

## Quick Start

### Installation (30 seconds)

```bash
curl -fsSL https://raw.githubusercontent.com/pauljump/idea-factory/main/install.sh | bash
```

This installs:
- `if-setup` - Create AI-ready workspace
- `if-sync` - Sync methodology globally
- `if-analytics` - View all project readiness

### Create Your First Idea (2 minutes)

```bash
# Create new idea
if-setup my-app

# Claude will scaffold:
# ✓ .claude/ - Conversation persistence
# ✓ .idea-factory/ - Methodology templates
# ✓ GitHub repo - External memory
# ✓ README - Auto-generated

# Start building
cd my-app
# Open Claude Code and say "continue"
```

### Work on Multiple Ideas (Unlimited)

```bash
# Setup 3 ideas
if-setup saas-platform
if-setup mobile-app
if-setup api-service

# Switch between them
cd saas-platform  # Say "continue" - full context restores
cd mobile-app     # Say "continue" - different context
cd api-service    # Say "continue" - yet another context

# View all projects
if-analytics
```

```
┌─────────────────────────────────────────────┐
│  Idea Factory Analytics                     │
├─────────────────────────────────────────────┤
│  saas-platform      █████████░ 85% ✓ READY  │
│  mobile-app         ██████░░░░ 58% ⚡ WIP   │
│  api-service        ████░░░░░░ 42% 💭 THINK │
│  Total: 150 projects                        │
└─────────────────────────────────────────────┘
```

---

## How It Works

### File-Based Memory

```
your-idea/
  .claude/                    # Conversation persistence
    conversations/            # Daily logs
    insights/                 # Extracted decisions, assumptions
    state/                    # Readiness score, session info

  .idea-factory/              # Methodology
    working-guide.md          # How to work with AI
    conversation-protocol.md  # Session protocol

  experiments/                # Validation tests
```

### The "Continue" Protocol

When you say **"continue"**, Claude:

1. Reads `.claude/state/session.json` (last session)
2. Reads `.claude/insights/all.json` (all decisions)
3. Checks `gh issue list` (GitHub external memory)
4. Generates context-aware greeting

**You pick up exactly where you left off.**

### Readiness Tracking

Don't code until readiness ≥ 70%.

```javascript
readiness = (
  coreValue      * 0.30 +    // Problem clarity
  mvpScope       * 0.25 +    // What to build
  techApproach   * 0.25 +    // How to build
  assumptions    * 0.10 +    // Validated?
  blockers       * 0.10      // Resolved?
)
```

**0-40%:** Keep talking
**40-70%:** Almost ready
**70-85%:** Start building
**85-100%:** Just ship

---

## Commands

### `if-setup <name>`
Create AI-ready workspace with full infrastructure

```bash
if-setup my-saas
# Creates project with .claude/, .idea-factory/, GitHub repo
```

### `if-sync`
Deploy methodology updates to all projects

```bash
# Edit master template
vim ~/.ideafactory/templates/working-guide.md

# Deploy to all 150 projects
if-sync
```

### `if-analytics`
Terminal dashboard showing all project readiness

```bash
if-analytics
# Interactive TUI showing readiness scores
```

---

## Use Cases

### Solo Founder with 50 Ideas
"I have notebooks full of ideas but can only focus on 1-2 because of context switching cost. **Idea Factory lets me work on all 50** and make progress on whatever feels right each day."

### AI Engineer Building Portfolio
"I was building 3 side projects but losing context between sessions. **Now I work on 12 projects** and each conversation picks up where I left off."

### Product Team Exploring Experiments
"We run constant experiments but lose findings. **Idea Factory tracks every decision and assumption** so nothing gets lost."

---

## Architecture

**Conversation Persistence:**
- Markdown logs in `.claude/conversations/`
- Structured insights in `.claude/insights/all.json`
- Readiness scoring in `.claude/state/readiness.json`

**Methodology as Infrastructure:**
- Master templates in `~/.ideafactory/templates/`
- Synced to all projects via `if-sync`
- Update once, deploy globally

**GitHub Integration:**
- Every idea = GitHub repo (external memory)
- Issues = open questions + async thoughts
- PRs = experiment results

**Zero Dependencies:**
- Pure bash (works everywhere)
- Only requires: `git`, `gh` (GitHub CLI)
- No npm, no Python, no Ruby

---

## Examples

### Example 1: SaaS Product
See [examples/002-saas-product/](examples/002-saas-product/) for a complete walkthrough building a SaaS from idea → ship using Idea Factory.

### Example 2: Weekend Project
See [examples/001-minimal-idea/](examples/001-minimal-idea/) for a 5-minute tutorial.

### Tutorial
See [examples/TUTORIAL.md](examples/TUTORIAL.md) for step-by-step guide.

---

## Documentation

- **[Getting Started](docs/getting-started.md)** - Installation and first steps
- **[Core Concepts](docs/core-concepts.md)** - How the system works
- **[Commands](docs/commands.md)** - Complete CLI reference
- **[Readiness System](docs/readiness-system.md)** - Scoring methodology
- **[GitHub Integration](docs/github-integration.md)** - Using GitHub as memory
- **[Advanced Usage](docs/advanced-usage.md)** - Power user tips
- **[Troubleshooting](docs/troubleshooting.md)** - Common issues

---

## Comparison to Other Tools

| Feature | Idea Factory | Notion | Linear | Obsidian |
|---------|--------------|--------|---------|----------|
| AI Context Persistence | ✅ | ❌ | ❌ | ❌ |
| Readiness Tracking | ✅ | ❌ | ❌ | ❌ |
| Methodology Sync | ✅ | ❌ | ❌ | ❌ |
| File-Based (no server) | ✅ | ❌ | ❌ | ✅ |
| GitHub Integration | ✅ | ❌ | ~️ | ❌ |
| Works with Claude | ✅ | ❌ | ❌ | ❌ |

---

## FAQ

**Q: Why not just use Notion?**
A: Notion doesn't persist AI conversation context. You still start from zero each session.

**Q: Do I need Claude Code?**
A: Works with any Claude interface that has file access. Claude Code is recommended.

**Q: Can I use this for non-code ideas?**
A: Yes! Works for any idea that benefits from iterative refinement with AI.

**Q: How many ideas can I manage?**
A: Tested with 150+ projects. No practical limit.

**Q: Does this work on Windows?**
A: Currently macOS/Linux. Windows support via WSL2 coming soon.

---

## Contributing

Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md).

**Areas we'd love help:**
- Windows native support
- Web dashboard (alternative to terminal UI)
- VS Code extension
- Integration tests

---

## License

MIT License - see [LICENSE](LICENSE)

---

## Credits

Built by [Paul Jump](https://github.com/pauljump) to solve personal context chaos while building 150 ideas with AI.

Inspired by:
- **[Continue](https://continue.dev/)** - AI code assistant
- **[Agent Relay](https://github.com/AgentWorkforce/relay)** - Agent messaging
- Personal pain of losing context across 150 projects

---

## Links

- **[GitHub](https://github.com/pauljump/idea-factory)**
- **[Documentation](docs/)**
- **[Examples](examples/)**
- **[Issues](https://github.com/pauljump/idea-factory/issues)**
- **[Discussions](https://github.com/pauljump/idea-factory/discussions)**

---

<div align="center">

**One word unlocks everything: continue**

Made with ❤️ for AI-native builders

</div>
