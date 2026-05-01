#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract data from JSON
current_dir=$(echo "$input" | jq -r '.workspace.current_dir')
username=$(whoami)
short_dir=$(basename "$current_dir")

# Initialize git info
git_info=""

# Check if we're in a git repository
if [ -d "$current_dir/.git" ]; then
    cd "$current_dir" 2>/dev/null
    
    # Get current branch
    branch=$(git branch --show-current 2>/dev/null || echo 'detached')
    
    # Get git status
    status_output=$(git status --porcelain 2>/dev/null)
    modified_count=$(echo "$status_output" | grep -c '^.M\|^M' 2>/dev/null || echo 0)
    untracked_count=$(echo "$status_output" | grep -c '^??' 2>/dev/null || echo 0)
    
    # Get ahead/behind info
    ahead_behind=$(git rev-list --left-right --count HEAD...@{upstream} 2>/dev/null || echo '0	0')
    ahead=$(echo "$ahead_behind" | cut -f1)
    behind=$(echo "$ahead_behind" | cut -f2)
    
    # Build git info without colors
    git_info=" on $branch"
    
    # Add status indicators without colors
    [ "$modified_count" -gt 0 ] && git_info="$git_info ~$modified_count"
    [ "$untracked_count" -gt 0 ] && git_info="$git_info +$untracked_count" 
    [ "$ahead" -gt 0 ] && git_info="$git_info ↑$ahead"
    [ "$behind" -gt 0 ] && git_info="$git_info ↓$behind"
fi

# Output the status line as plain text without color codes
echo "$username in $short_dir$git_info"