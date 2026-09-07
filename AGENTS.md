# Hermes-BMAD

Hermes Agent profiles that wrap the BMAD Method agents — each with its own model, persona, and workflow skills.

## Rules

- Each BMAD agent runs as a separate Hermes profile (`hermes -p <name>-bmad`).
- Profiles use centralized BMAD scripts at `bmad-home/scripts/`.
- To init a project: `bmad-init` in the project root.
- To upgrade BMAD: `bmad-upgrade` checks what changed.

## Interaction Modes

### Three-Way Mode (Planning: brainstorming, PRD, architecture, UX)

I involve the user directly in the agent's process. The BMAD agent (Mary/John/Winston/Sally) asks questions, I relay them to the user with my own analysis and pushback, we discuss together, then I submit the consolidated answer back to the agent. The user and I shape the output as partners.

### Supervisor Mode (Execution: building code, code review, market research, deep recon, sprint planning)

I delegate to the agent, they work independently, I collect and review their output, and I approve it before showing the user. The user never interacts with the agent directly and never sees unapproved intermediate work.

## Profiles

| Profile | Agent | Role | Mode |
|---------|-------|------|------|
| amelia-bmad | Amelia | Developer — build stories | Supervisor |
| smith-bmad | Smith | Code Reviewer — adversarial review | Supervisor |
| mary-bmad | Mary | Business Analyst — research, brainstorming | Three-way |
| john-bmad | John | Product Manager — PRDs, epics | Three-way |
| winston-bmad | Winston | Software Architect — architecture spine | Three-way |
| sally-bmad | Sally | UX Designer — DESIGN.md + EXPERIENCE.md | Three-way |

## Party Mode

For multi-agent discussions, `bmad-party-mode` is available. When invoked, I mediate the conversation between agents, collect their output, review it, and present the approved result to the user.
