# Create a new feature branch off main
# Usage: gnb feature-name
function gnb() {
  if [ -z "$1" ]; then
    echo "Usage: gnb <branch-name>"
    return 1
  fi
  git checkout main && \
  git pull origin main && \
  git checkout -b "$1"
}

# Create a child branch off current branch
# Usage: gchild child-branch-name
function gchild() {
  if [ -z "$1" ]; then
    echo "Usage: gchild <child-branch-name>"
    return 1
  fi
  local parent=$(git branch --show-current)
  echo "Creating child branch '$1' off parent '$parent'"
  git checkout -b "$1"
}

# Collapse current branch onto main (after parent is merged)
# Usage: gcollapse
function gcollapse() {
  local current=$(git branch --show-current)
  if [ "$current" = "main" ]; then
    echo "Already on main branch"
    return 1
  fi
  
  echo "Collapsing '$current' onto main..."
  git checkout main && \
  git pull origin main && \
  git checkout "$current" && \
  git rebase main && \
  echo "Branch collapsed successfully. Use 'gpf' to force push if needed."
}

# Sync current branch with its parent branch
# Usage: gsyncparent parent-branch-name
function gsyncparent() {
  if [ -z "$1" ]; then
    echo "Usage: gsyncparent <parent-branch-name>"
    return 1
  fi
  local current=$(git branch --show-current)
  echo "Syncing '$current' with parent '$1'..."
  git checkout "$1" && \
  git pull origin "$1" && \
  git checkout "$current" && \
  git rebase "$1"
}

# Clean up after parent branch is merged
# Deletes parent branch and collapses current onto main
# Usage: gcleanup parent-branch-name
function gcleanup() {
  if [ -z "$1" ]; then
    echo "Usage: gcleanup <merged-parent-branch-name>"
    return 1
  fi
  local current=$(git branch --show-current)
  local parent="$1"
  
  echo "Cleaning up merged parent branch '$parent' and collapsing '$current' onto main..."
  git checkout main && \
  git pull origin main && \
  git branch -d "$parent" && \
  git checkout "$current" && \
  git rebase main && \
  echo "Cleanup complete. Parent branch deleted, current branch rebased onto main."
  echo "Use 'gpf' to force push if needed."
}

# Interactive rebase with main
# Usage: grim
function grim() {
  git rebase -i main
}

# Show current branch and its base
# Usage: ginfo
function ginfo() {
  local current=$(git branch --show-current)
  local base=$(git merge-base main HEAD)
  local base_commit=$(git log --oneline -1 "$base")
  
  echo "Current branch: $current"
  echo "Base commit: $base_commit"
  echo "Commits ahead of main: $(git rev-list --count main..HEAD)"
  echo "Commits behind main: $(git rev-list --count HEAD..main)"
}

# Complete workflow helper with prompts
# Usage: gworkflow
function gworkflow() {
  echo "Git Workflow Helper"
  echo "=================="
  echo "1. Create new feature branch off main"
  echo "2. Create child branch off current branch"
  echo "3. Sync child with parent branch"
  echo "4. Collapse child onto main (after parent merged)"
  echo "5. Full cleanup (delete parent + collapse child)"
  echo ""
  echo -n "Choose option (1-5): "
  read option
  
  case $option in
    1)
      echo -n "Enter branch name: "
      read branch_name
      gnb "$branch_name"
      ;;
    2)
      echo -n "Enter child branch name: "
      read branch_name
      gchild "$branch_name"
      ;;
    3)
      echo -n "Enter parent branch name: "
      read parent_name
      gsyncparent "$parent_name"
      ;;
    4)
      gcollapse
      ;;
    5)
      echo -n "Enter merged parent branch name: "
      read parent_name
      gcleanup "$parent_name"
      ;;
    *)
      echo "Invalid option"
      ;;
  esac
}
