# Hermes-BMAD

Hermes Agent profiles that wrap the BMAD Method agents — each with its own model, persona, and workflow skills.

## Rules

- Each BMAD agent runs as a separate Hermes profile (`hermes -p <name>-bmad`).
- Profiles use centralized BMAD scripts at `bmad-home/scripts/`.
- To init a project: `bmad-init` in the project root.
- To upgrade BMAD: `bmad-upgrade` checks what changed.

## Profiles

| Profile | Agent | Role |
|---------|-------|------|
| amelia-bmad | Amelia | Developer — build stories |
| smith-bmad | Smith | Code Reviewer — adversarial review |
| mary-bmad | Mary | Business Analyst — research, brainstorming |
| john-bmad | John | Product Manager — PRDs, epics |
| winston-bmad | Winston | Software Architect — architecture spine |
| sally-bmad | Sally | UX Designer — DESIGN.md + EXPERIENCE.md |
