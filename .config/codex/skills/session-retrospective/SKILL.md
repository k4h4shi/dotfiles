---
name: session-retrospective
description: Analyze a Claude Code session and suggest configuration improvements. Use when reviewing a completed session to identify opportunities for permissions, memory/rules, skills, agents, or hooks improvements. Triggers on requests like "retrospective", "session analysis", "improve Claude config", or when given a Claude session ID.
---

# Session Retrospective

Analyze a Claude Code session log and suggest configuration improvements.

## Input

- **Session ID**: Provided as argument (e.g., `/session-retrospective abc-123-def`)
- **Session File**: `~/.claude/projects/*/<SESSION_ID>.jsonl`
- **Debug Log**: `~/.claude/debug/<SESSION_ID>.txt` (optional)

## Session Log Format

JSONL with records like:
```json
{"type": "user", "message": {"role": "user", "content": "..."}}
{"type": "assistant", "message": {"role": "assistant", "content": [{"type": "tool_use", "name": "...", "input": {...}}]}}
```

## Analysis Process

### 1. Read Session Files

```bash
# Find session file
find ~/.claude/projects -name "<SESSION_ID>.jsonl" 2>/dev/null

# Read session log
cat <SESSION_FILE>

# Read debug log if exists
cat ~/.claude/debug/<SESSION_ID>.txt 2>/dev/null
```

### 2. Analyze and Suggest Improvements

#### Permissions (`settings.json`)
- Look for `Permission suggestions for` in debug log
- Identify commands that required manual approval
- Suggest `permissions.allow` rules

#### Memory / Rules (`CLAUDE.md`, `.claude/rules/`)
- Find repeated explanations from user
- Find `AskUserQuestion` tool calls with similar questions
- Suggest content for CLAUDE.md or path-specific rules

#### Skills (`.claude/skills/<name>/SKILL.md`)
- Identify repeated multi-step workflows
- Find manual instructions given multiple times
- Suggest skill definitions with frontmatter

#### Agents (`.claude/agents/<name>.md`)
- Find repeated `Task` tool delegations with same patterns
- Identify common subagent_type + description combinations
- Suggest custom agent definitions

#### Hooks (`settings.json`)
- Find repeated pre/post processing steps
- Identify manual formatting or validation tasks
- Suggest hook configurations

### 3. Create Report

Save to `~/.claude/retrospectives/<SESSION_ID>.md`:

```markdown
# Session Retrospective: <SESSION_ID>

**Date**: YYYY-MM-DD
**Project**: /path/to/project

## Session Summary
[What was accomplished]

## What Went Well
- [Successes]

## Suggested Improvements

### 1. Permissions
```json
{"permissions": {"allow": ["Bash(command:*)"]}}
```
**Reason**: [Why this helps]

### 2. Memory / Rules
```markdown
# Content to add
```
**Reason**: [Why this helps]

### 3. Skills
```yaml
---
name: skill-name
description: ...
---
```
**Reason**: [Why this helps]

### 4. Agents
```yaml
---
name: agent-name
tools: Read, Grep
---
```
**Reason**: [Why this helps]

### 5. Hooks
```json
{"hooks": {...}}
```
**Reason**: [Why this helps]

## Action Items
- [ ] Specific action 1
- [ ] Specific action 2
```

## Reference Documentation

- Memory: https://code.claude.com/docs/en/memory
- Skills: https://code.claude.com/docs/en/skills
- Slash Commands: https://code.claude.com/docs/en/slash-commands
- Sub-agents: https://code.claude.com/docs/en/sub-agents
- Hooks: https://code.claude.com/docs/en/hooks-guide
