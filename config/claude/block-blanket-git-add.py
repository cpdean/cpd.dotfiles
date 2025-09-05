#!/usr/bin/env python3
import json
import re
import sys

try:
    input_data = json.load(sys.stdin)
    command = input_data.get("tool_input", {}).get("command", "")
    
    # Block dangerous git add patterns
    if re.match(r'^git\s+add\s+\.$', command.strip()) or re.match(r'^git\s+add\s+-A(\s+\.)?$', command.strip()):
        print("❌ Blocked: Use 'git add -u' to stage modified files only, or 'git add path/to/file' for specific files", file=sys.stderr)
        sys.exit(2)
        
except Exception as e:
    print(f"Hook error: {e}", file=sys.stderr)
    sys.exit(1)
