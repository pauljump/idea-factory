# Getting Started with Idea Factory

Welcome to Idea Factory! This guide will help you get up and running in under 5 minutes.

## What is Idea Factory?

Idea Factory is infrastructure for AI-native development that solves the context loss problem. Instead of starting every Claude conversation from zero, you say **"continue"** and full context restores instantly.

## Installation

### Quick Install (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/pauljump/idea-factory/main/install.sh | bash
```

This installs:
- `if-setup` - Create AI-ready workspaces
- `if-sync` - Sync methodology globally
- `if-analytics` - View readiness dashboard

### Manual Install

```bash
# Clone repo
git clone https://github.com/pauljump/idea-factory ~/.ideafactory

# Add to PATH
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# Create symlinks
ln -s ~/.ideafactory/bin/if-setup ~/.local/bin/if-setup
ln -s ~/.ideafactory/bin/if-sync ~/.local/bin/if-sync
ln -s ~/.ideafactory/bin/if-analytics ~/.local/bin/if-analytics
```

### Verify Installation

```bash
if-setup --help
# Should show help message
```

## Prerequisites

Required:
- **macOS or Linux** (Windows via WSL2 coming soon)
- **git** - Version control
- **gh** (GitHub CLI) - For GitHub integration

Install GitHub CLI:
```bash
# macOS
brew install gh

# Linux
# See: https://github.com/cli/cli/blob/trunk/docs/install_linux.md
```

Authenticate GitHub CLI:
```bash
gh auth login
```

## Create Your First Project

### Step 1: Scaffold Project

```bash
if-setup my-first-idea
```

This creates:
```
~/Desktop/projects/my-first-idea/
  ├── .claude/                # Conversation persistence
  │   ├── conversations/      # Daily logs
  │   ├── insights/          # Extracted decisions
  │   └── state/             # Readiness tracking
  ├── .idea-factory/         # Methodology
  ├── experiments/           # Validation tests
  ├── README.md
  └── .gitignore
```

Plus:
- GitHub repository created
- Initial git commit
- Basic structure ready

Time: ~30 seconds

### Step 2: Start Conversation

```bash
cd my-first-idea
# Open Claude Code
```

Say: **"continue"**

Claude responds:
```
Welcome to my-first-idea.

This is a new project. Let's start by defining:
- What problem are we solving?
- Who is the primary user?
- What's the core value?

What should we work on?
```

### Step 3: Have a Conversation

Talk to Claude about your idea:

```
User: "This is an app for tracking warranty claims.
       Users forward warranty emails and we auto-generate claims."

Claude: "Got it. Let me clarify a few things..."
[conversation continues]
```

Claude automatically:
- Logs conversation to `.claude/conversations/2026-01-28.md`
- Extracts decisions to `.claude/insights/all.json`
- Updates readiness score in `.claude/state/readiness.json`

### Step 4: Close and Resume

Close your laptop. Come back tomorrow.

```bash
cd my-first-idea
# Open Claude Code
```

Say: **"continue"**

```
Welcome back to my-first-idea.

Last session: 1 day ago
Readiness: 35% (exploring)

Decisions made:
✅ Use Gmail API for email parsing
✅ SQLite for initial storage

Open questions:
⚠️ How to handle non-email warranties?

Next: Test Gmail API permissions flow

What should we work on?
```

**Full context restored!**

## Working on Multiple Ideas

### Create Multiple Projects

```bash
if-setup saas-platform
if-setup mobile-app
if-setup api-service
```

### Switch Between Them

```bash
cd saas-platform
# Say "continue" - full context for this idea

cd mobile-app
# Say "continue" - full context for different idea

cd api-service
# Say "continue" - yet another context
```

### View All Projects

```bash
if-analytics
```

```
┌─────────────────────────────────────────────┐
│  Idea Factory Analytics                     │
├─────────────────────────────────────────────┤
│  saas-platform      █████████░ 85% ✓ READY  │
│  mobile-app         ██████░░░░ 58% ⚡ WIP   │
│  api-service        ████░░░░░░ 42% 💭 THINK │
│  Total: 3 projects                          │
└─────────────────────────────────────────────┘
```

## Understanding Readiness

Idea Factory tracks **readiness** (0-100%) to indicate when to start building.

**0-40%: Exploring**
- Keep talking
- Define problem, user, value
- Don't code yet

**40-70%: Designing**
- Getting clearer
- Define MVP scope
- Choose technical approach

**70-85%: Ready to Build**
- Perfect prompt achieved
- Start coding now

**85-100%: Ship It**
- Just execute
- Everything is clear

### Why Track Readiness?

Traditional approach: Talk for 10 minutes, start coding, realize you're building the wrong thing.

Idea Factory approach: Talk until readiness ≥ 70%, then build with confidence.

## Next Steps

Now that you understand the basics:

1. **Read [Core Concepts](core-concepts.md)** - Understand how it works
2. **Read [Commands](commands.md)** - Learn all commands
3. **Try the [Tutorial](../examples/TUTORIAL.md)** - Step-by-step walkthrough
4. **Improve your methodology** - Edit `~/.ideafactory/templates/.idea-factory/working-guide.md`

## Common Questions

**Q: Do I need Claude Code?**
A: Works with any Claude interface with file access. Claude Code recommended.

**Q: Where are my projects stored?**
A: Default: `~/Desktop/projects/`. Change with: `vim ~/.ideafactory/config`

**Q: Can I use this for non-code projects?**
A: Yes! Works for any idea that benefits from AI refinement.

**Q: How many ideas can I manage?**
A: Tested with 150+ projects. No practical limit.

**Q: Does this replace Notion/Linear?**
A: Different purpose. This persists AI context, not task management.

## Need Help?

- [Full Documentation](README.md)
- [GitHub Issues](https://github.com/pauljump/idea-factory/issues)
- [Discussions](https://github.com/pauljump/idea-factory/discussions)

---

**Ready to build 150 ideas without chaos? Let's go! 🚀**
