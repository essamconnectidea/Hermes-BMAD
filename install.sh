#!/usr/bin/env bash
# Hermes-BMAD Installer
# Installs BMAD Method agent profiles into Hermes

set -e

HERMES_BMAD="$(cd "$(dirname "$0")" && pwd)"
HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"
BMAD_METHOD="$HERMES_BMAD/bmad-method"
BMAD_HOME_TARGET="$HERMES_HOME/bmad-home"
BIN_TARGET="$HERMES_HOME/bin"
PROFILES_TARGET="$HERMES_HOME/profiles"

echo "================================================"
echo " Hermes-BMAD Installer"
echo "================================================"
echo ""
echo "  Source:      $HERMES_BMAD"
echo "  Hermes home: $HERMES_HOME"
echo ""

# ── Step 1: Check prerequisites ──
if ! command -v hermes &>/dev/null; then
    echo "Error: 'hermes' not found in PATH. Install Hermes Agent first."
    exit 1
fi
if ! command -v uv &>/dev/null; then
    echo "Warning: 'uv' not found. BMAD Python scripts may not run."
    echo "  Install: curl -LsSf https://astral.sh/uv/install.sh | sh"
fi

# ── Step 2: Clone BMAD-METHOD (if not present) ──
if [ -d "$BMAD_METHOD/.git" ]; then
    echo "[2/6] BMAD-METHOD already cloned at $BMAD_METHOD"
else
    echo "[2/6] Cloning BMAD-METHOD (pinned)..."
    git clone --depth 1 --branch v6.12.0 https://github.com/bmad-code-org/BMAD-METHOD.git "$BMAD_METHOD"
fi

# ── Step 3: Detect Hermes model config ──
echo "[3/6] Detecting Hermes model config..."
if [ -f "$HERMES_HOME/config.yaml" ]; then
    HERMES_PROVIDER=$(grep -A2 '^model:' "$HERMES_HOME/config.yaml" | grep 'provider:' | awk '{print $2}' | head -1)
    HERMES_MODEL=$(grep -A3 '^model:' "$HERMES_HOME/config.yaml" | grep 'default:' | awk '{print $2}' | head -1)
    HERMES_BASE_URL=$(grep -A5 '^model:' "$HERMES_HOME/config.yaml" | grep 'base_url:' | awk '{print $2}' | head -1)
fi
HERMES_PROVIDER="${HERMES_PROVIDER:-openrouter}"
HERMES_MODEL="${HERMES_MODEL:-deepseek/deepseek-v4-flash}"
HERMES_BASE_URL="${HERMES_BASE_URL:-https://openrouter.ai/api/v1}"
echo "  Provider: $HERMES_PROVIDER"
echo "  Model:    $HERMES_MODEL"

# ── Step 4: Create profile directories ──
echo "[4/6] Creating profiles..."
mkdir -p "$PROFILES_TARGET"

create_profile() {
    local NAME=$1
    local MODEL=$2
    local DIR="$PROFILES_TARGET/$NAME"
    mkdir -p "$DIR/skills"
    
    # Write config.yaml
    cat > "$DIR/config.yaml" <<CONFIG
model:
  default: $MODEL
  provider: $HERMES_PROVIDER
  base_url: $HERMES_BASE_URL
  api_mode: chat_completions
auxiliary:
  vision:
    provider: $HERMES_PROVIDER
    model: google/gemini-2.5-flash
web:
  extract_backend: defuddle
platform_toolsets:
  cli:
    - file
    - search
    - terminal
    - web
    - vision
    - memory
    - skills
known_builtin_toolsets:
  cli:
    - file
    - search
    - terminal
    - web
    - vision
    - memory
    - skills
known_plugin_toolsets:
  cli: []
plugins:
  enabled: []
  disabled: []
memory:
  max_chars: 5000
voice:
  auto_tts: false
  beep_enabled: false
browser:
  cloud_provider: local
  use_gateway: false
onboarding:
  seen:
    tool_progress_prompt: true
    busy_input_prompt: true
_config_version: 40
CONFIG
    
    # Link .env
    if [ -f "$HERMES_HOME/.env" ]; then
        ln -sf "$HERMES_HOME/.env" "$DIR/.env"
    fi
    
    # Link BMAD skills from cloned method
    local SKILL_SOURCE="$BMAD_METHOD/skills"
    local SKILLS_LIST=("${@:3}")
    for SKILL in "${SKILLS_LIST[@]}"; do
        if [ -d "$SKILL_SOURCE/$SKILL" ]; then
            ln -sf "$SKILL_SOURCE/$SKILL" "$DIR/skills/$SKILL"
        fi
    done
    
    # Copy persona SKILL.md from Hermes-BMAD
    if [ -f "$HERMES_BMAD/profiles/$NAME/SKILL.md" ]; then
        cp "$HERMES_BMAD/profiles/$NAME/SKILL.md" "$DIR/skills/"
    fi
    
    # Copy party-mode mediator if present
    if [ -f "$HERMES_BMAD/profiles/party-mediator.skill.md" ]; then
        cp "$HERMES_BMAD/profiles/party-mediator.skill.md" "$DIR/skills/PARTY_MEDIATOR.md"
    fi
    
    # Copy orchestrator skill if present
    if [ -f "$HERMES_BMAD/profiles/orchestrator.skill.md" ]; then
        cp "$HERMES_BMAD/profiles/orchestrator.skill.md" "$DIR/skills/HERMES_BMAD_ORCHESTRATOR.md"
    fi
    
    echo "  Created $NAME"
}

# Create each profile with its model and skills
create_profile "amelia-bmad" "$HERMES_MODEL" "bmad-build" "bmad-spec" "bmad-project-context" "bmad-agent-dev"
create_profile "smith-bmad" "nvidia/nemotron-3-ultra-550b-a55b:free" "bmad-code-review" "bmad-review" "bmad-agent-dev"
create_profile "mary-bmad" "$HERMES_MODEL" "bmad-brainstorming" "bmad-deep-recon" "bmad-product-brief" "bmad-prfaq" "bmad-forge-idea" "bmad-help" "bmad-agent-analyst" "bmad-party-mode"
create_profile "john-bmad" "$HERMES_MODEL" "bmad-prd" "bmad-create-epics-and-stories" "bmad-sprint-planning" "bmad-correct-course" "bmad-help" "bmad-agent-pm" "bmad-party-mode"
create_profile "winston-bmad" "$HERMES_MODEL" "bmad-architecture" "bmad-project-context" "bmad-help" "bmad-agent-architect" "bmad-party-mode"
create_profile "sally-bmad" "$HERMES_MODEL" "bmad-ux" "bmad-help" "bmad-agent-ux-designer" "bmad-party-mode"

# ── Step 5: Install centralized BMAD home ──
echo "[5/6] Installing centralized BMAD home..."
mkdir -p "$BMAD_HOME_TARGET/scripts" "$BMAD_HOME_TARGET/custom"
cp "$HERMES_BMAD/bmad-home/config.toml" "$BMAD_HOME_TARGET/config.toml"
cp "$HERMES_BMAD/bmad-home/scripts/"*.py "$BMAD_HOME_TARGET/scripts/"

# ── Step 6: Install CLI tools ──
echo "[6/6] Installing CLI tools..."
mkdir -p "$BIN_TARGET"
cp "$HERMES_BMAD/bin/bmad-init" "$BIN_TARGET/bmad-init"
cp "$HERMES_BMAD/bin/bmad-upgrade" "$BIN_TARGET/bmad-upgrade"

# Add to PATH if not already
if [[ ":$PATH:" != *":$BIN_TARGET:"* ]]; then
    SHELL_CONFIG="$HOME/.bashrc"
    echo "export PATH=\"\$PATH:$BIN_TARGET\"" >> "$SHELL_CONFIG"
    echo "  Added $BIN_TARGET to PATH in $SHELL_CONFIG"
fi

echo ""
echo "================================================"
echo " Hermes-BMAD installed!"
echo "================================================"
echo ""
echo "Try an agent:"
echo "  hermes -p mary-bmad"
echo ""
echo "Init a project for BMAD:"
echo "  cd ~/Projects/my-app && bmad-init"
echo ""
echo "Upgrade BMAD:"
echo "  bmad-upgrade"
echo ""