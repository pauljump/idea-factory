# Contributing to Idea Factory

First off, thank you for considering contributing to Idea Factory! It's people like you that make it such a great tool.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the existing issues to avoid duplicates. When you create a bug report, include as many details as possible:

- **Use a clear and descriptive title**
- **Describe the exact steps to reproduce the problem**
- **Provide specific examples**
- **Describe the behavior you observed and what you expected**
- **Include your OS and shell version**
- **Include relevant config from `~/.ideafactory/config`**

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion:

- **Use a clear and descriptive title**
- **Provide a detailed description of the proposed enhancement**
- **Explain why this enhancement would be useful**
- **List any examples of other tools that have this feature**

### Pull Requests

1. Fork the repo and create your branch from `main`
2. If you've added code, add tests
3. Ensure the test suite passes
4. Make sure your code follows the existing style
5. Write a clear commit message

## Development Setup

```bash
# Clone your fork
git clone https://github.com/<your-username>/idea-factory
cd idea-factory

# Create a branch
git checkout -b feature/my-feature

# Make changes and test locally
./install.sh  # Test installer

# Test individual commands
bin/if-setup test-project
bin/if-sync
bin/if-analytics

# Run tests
bash tests/test-install.sh
bash tests/test-scaffold.sh
```

## Style Guidelines

### Bash Style

- Use `#!/bin/bash` shebang
- Use `set -e` for error handling
- Indent with 4 spaces
- Use lowercase for variable names
- Use UPPERCASE for constants
- Quote variables: `"$variable"`
- Use functions for reusable code
- Comment complex sections

Example:
```bash
#!/bin/bash
set -e

CONSTANT_VALUE="foo"
local_variable="bar"

# Complex operation explanation
function do_something() {
    local param="$1"
    echo "Processing $param"
}
```

### Commit Messages

- Use present tense ("Add feature" not "Added feature")
- Use imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit first line to 72 characters
- Reference issues and PRs liberally

Example:
```
Add terminal UI for analytics dashboard

- Create interactive TUI using ncurses
- Add real-time readiness updates
- Support keyboard navigation

Fixes #123
```

## Areas We Need Help

### High Priority
- [ ] Windows support (native or WSL2)
- [ ] Web dashboard (alternative to terminal UI)
- [ ] VS Code extension
- [ ] Comprehensive integration tests
- [ ] Performance optimization for 500+ projects

### Medium Priority
- [ ] Shell completion (bash/zsh)
- [ ] Plugin system for custom templates
- [ ] Export/import functionality
- [ ] Analytics visualizations
- [ ] Multi-language support

### Nice to Have
- [ ] Docker support
- [ ] CI/CD pipeline templates
- [ ] Mobile companion app
- [ ] Slack/Discord integrations

## Testing

We use bash scripts for testing:

```bash
# Run all tests
bash tests/test-all.sh

# Run specific test
bash tests/test-install.sh
bash tests/test-scaffold.sh
bash tests/test-sync.sh
```

### Writing Tests

Add tests to `tests/` directory:

```bash
#!/bin/bash
# tests/test-my-feature.sh

source "$(dirname "$0")/../lib/utils.sh"

# Test case
test_my_feature() {
    # Setup
    local test_dir=$(mktemp -d)

    # Execute
    result=$(my_function "arg")

    # Assert
    if [ "$result" = "expected" ]; then
        log_success "Test passed"
        return 0
    else
        log_error "Test failed: expected 'expected', got '$result'"
        return 1
    fi

    # Cleanup
    rm -rf "$test_dir"
}

# Run test
test_my_feature
```

## Documentation

- Update README.md for user-facing changes
- Update docs/ for detailed documentation
- Add inline comments for complex logic
- Update examples/ if adding new features

## Code Review Process

1. Create a PR with clear description
2. Reference related issues
3. Wait for CI to pass
4. Address review feedback
5. Maintainer will merge when ready

## Community

- Be respectful and constructive
- Help others in issues and discussions
- Share your use cases and examples
- Spread the word about Idea Factory

## Recognition

Contributors will be:
- Added to CONTRIBUTORS.md
- Mentioned in release notes
- Celebrated in our community

## Questions?

- Open an issue for discussion
- Join our [Discussions](https://github.com/pauljump/idea-factory/discussions)
- Email: paul@example.com (replace with actual)

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for helping make Idea Factory better! 🚀
