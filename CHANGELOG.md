# Changelog

All notable changes to Hermes-BMAD are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/). Versioning follows [SemVer](https://semver.org/).

## [Unreleased]

### Pending
- First real-world workflow validation (PRD, architecture, UX, build, review)

## [1.0.0] - 2026-09-07

### Added
- 6 BMAD agent profiles: amelia (Developer), smith (Code Reviewer), mary (Analyst), john (PM), winston (Architect), sally (UX)
- Centralized `bmad-home/` runtime: resolve_config.py, resolve_customization.py, config_utils.py, default config.toml
- `bmad-init` CLI tool: one-command project setup (docs/, bmad-output/, _bmad/ symlink)
- `bmad-upgrade` CLI tool: checks latest BMAD-METHOD tag before upgrading
- `install.sh`: clones BMAD-METHOD at pinned v6.12.0, auto-detects user's Hermes model config, creates all profiles, installs CLI tools
- `uninstall.sh`: clean removal of all profiles, tools, and BMAD home
- Interaction modes documented: Three-way (planning) and Supervisor (execution)
- `orchestrator.skill.md`: routing rules and mode control for the orchestrating Hermes
- `party-mediator.skill.md`: mediation protocol for multi-agent (party mode) discussions
- `bmad-party-mode` linked into all planning profiles (mary, john, winston, sally)
- Persona SKILL.md wrappers for all 6 agents
- AGENTS.md project context

### Notes
- BMAD-METHOD pinned at v6.12.0 — structural upgrades are reviewed before bumping
- Requires: Hermes Agent, uv, Python 3.11+