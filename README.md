# Hermes-BMAD

> BMAD Method agents, baked into Hermes. Clone once, use in any project.

**Hermes-BMAD** gives you 6 named BMAD agent personas as Hermes profiles — each with its own model, its own workflow skills, and a centralized runtime that works in any project without per-project BMAD installs.

## Agents

| Profile | Agent | Role | Typical Model |
|---------|-------|------|---------------|
| `amelia-bmad` | Amelia | Developer — build stories | `deepseek/deepseek-v4-flash` |
| `smith-bmad` | Smith | Code Reviewer — adversarial review | `nvidia/nemotron-3-ultra-550b-a55b:free` |
| `mary-bmad` | Mary | Business Analyst — research, brainstorming | `deepseek/deepseek-v4-flash` |
| `john-bmad` | John | Product Manager — PRDs, epics | `deepseek/deepseek-v4-flash` |
| `winston-bmad` | Winston | Architect — architecture spine, ADRs | `deepseek/deepseek-v4-flash` |
| `sally-bmad` | Sally | UX Designer — DESIGN.md + EXPERIENCE.md | `deepseek/deepseek-v4-flash` |

## Quick Install

```bash
git clone https://github.com/essamconnectidea/Hermes-BMAD.git ~/.hermes-bmad
cd ~/.hermes-bmad
bash install.sh
```

The installer will:
1. Clone BMAD-METHOD (pinned to v6.12.0)
2. Detect your Hermes model config and pre-fill profile configs
3. Copy profiles to `~/.hermes/profiles/*-bmad/`
4. Install `bmad-init` and `bmad-upgrade` into `~/.hermes/bin/`
5. Link centralized BMAD scripts

## Usage

### Init a project for BMAD

```bash
cd ~/Projects/my-app
bmad-init
# Creates: docs/, bmad-output/, _bmad/ -> ~/.hermes/bmad-home (symlink)
```

### Run an agent

```bash
hermes -p mary-bmad    # Mary for brainstorming/research
hermes -p john-bmad    # John for PRDs/epics
hermes -p winston-bmad  # Winston for architecture
hermes -p amelia-bmad  # Amelia for building
hermes -p smith-bmad   # Smith for code review
hermes -p sally-bmad   # Sally for UX design
```

## Architecture

```
~/.hermes-bmad/              # Hermes-BMAD repo
├── bmad-method/             # BMAD-METHOD (cloned at pinned tag)
├── bmad-home/               # Centralized runtime scripts
│   ├── config.toml          # Default project config
│   └── scripts/             # resolve_config.py, resolve_customization.py
├── profiles/                # Profile SKILL.md templates
└── install.sh               # One-command install

~/.hermes/profiles/*-bmad/   # Installed profiles
~/.hermes/bmad-home/         # Runtime scripts (copied)
~/.hermes/bin/bmad-init      # Project init
~/.hermes/bin/bmad-upgrade   # BMAD version check

my-project/
├── docs/                    # Planning artifacts
├── bmad-output/             # Workflow outputs
├── _bmad/ -> ~/.hermes/bmad-home/  # Symlink
└── (app code)/
```

## Requirements

- [Hermes Agent](https://github.com/NousResearch/hermes-agent) installed
- [uv](https://docs.astral.sh/uv/) for BMAD Python scripts
- Python 3.11+

## License

MIT