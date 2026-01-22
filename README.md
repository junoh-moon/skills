# Skills

Agent skills for Claude Code and other AI coding assistants.

## Available Skills

| Skill | Description |
|-------|-------------|
| [commit-message](./skills/commit-message) | Generate conventional commit messages from staged changes |
| [gemini](./skills/gemini) | Interact with Google's Gemini model via CLI for multi-turn conversations |
| [pull-request](./skills/pull-request) | Create or update GitHub pull requests with theme-based commit grouping |

## Installation

```bash
npx skills add junoh-moon/skills --skill "gemini"
```

Or manually copy to:
- Claude Code: `~/.claude/skills/`
- Codex CLI: `~/.codex/skills/`
- Cursor: `.cursor/skills/` (project) or `~/.cursor/skills/` (global)

## License

MIT
