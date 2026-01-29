#!/usr/bin/env bash
set -euo pipefail

# Gemini CLI wrapper with streaming output and session management

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS] "prompt"

Options:
    --resume <session_id>    Continue a previous conversation
    --model <model>          Model to use (default: auto-gemini-3)
                             Options: auto-gemini-3, auto-gemini-2.5,
                                      gemini-2.5-flash, gemini-2.5-pro
    -h, --help               Show this help

Examples:
    $(basename "$0") "Explain this code"
    $(basename "$0") --resume abc-123 "Can you elaborate?"
    $(basename "$0") --model auto-gemini-2.5 "Use Gemini 2.5"
EOF
    exit 0
}

# Parse arguments
SESSION_ID=""
PROMPT=""
MODEL="auto-gemini-3"

while [[ $# -gt 0 ]]; do
    case $1 in
        --resume)
            SESSION_ID="$2"
            shift 2
            ;;
        --model)
            MODEL="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            PROMPT="$1"
            shift
            ;;
    esac
done

if [[ -z "$PROMPT" ]]; then
    echo "Error: prompt required" >&2
    usage
fi

# Create temp file for raw response
tmpfile=$(mktemp)
mv "$tmpfile" "${tmpfile}.json"
tmpfile="${tmpfile}.json"
echo "---"
echo "Response file: $tmpfile"
echo "---"

# Build command
cmd=(gemini --model "$MODEL" --approval-mode yolo --output-format stream-json)

if [[ -n "$SESSION_ID" ]]; then
    cmd+=(--resume "$SESSION_ID")
fi

cmd+=(-p "$PROMPT")

# Execute with tee
"${cmd[@]}" | tee "$tmpfile"

# Extract session_id for next turn (from init line)
echo ""
echo "---"
if session_id=$(jq -r 'select(.type == "init") | .session_id // empty' "$tmpfile" 2>/dev/null | head -1) && [[ -n "$session_id" ]]; then
    echo "Session ID: $session_id"
    echo "To continue: $(basename "$0") --resume $session_id \"your follow-up\""
else
    echo "Warning: Could not extract session_id. Check raw response: $tmpfile"
fi
