#!/usr/bin/env bash
# Repo-layer purity check — enforces ADR-013.
#
# Fires on Stop. Looks at the working-tree diff vs HEAD and flags any
# NEWLY-ADDED import of `lib/core/models/...` inside `lib/repos/`.
# Exits 2 (blocking) so the message is surfaced back to Claude.
#
# Existing violations in HEAD are not flagged — only changes introduced
# this session. To audit the whole repo manually, run:
#   grep -nE "import.*core/models/" lib/repos/**/*.dart

set -uo pipefail

repo_root="$(git rev-parse --show-toplevel 2>/dev/null)" || exit 0
cd "$repo_root" || exit 0

# Pull added lines (lines starting with `+` but not `+++` headers) from any
# lib/repos/*.dart file in the working-tree diff.
violations=$(git diff HEAD -- 'lib/repos/' 2>/dev/null | awk '
  /^diff --git a\/lib\/repos\// {
    file = $4
    sub("^b/", "", file)
    next
  }
  /^\+[^+]/ {
    if (match($0, /import[^;]*core\/models\/[^;]*/)) {
      printf "  %s\n      %s\n", file, substr($0, RSTART, RLENGTH)
    }
  }
')

if [ -n "$violations" ]; then
  cat >&2 <<EOF
Repo-layer purity violation (ADR-013):

$violations

Files under lib/repos/ must not import Dart model classes from lib/core/models/.
Repo public methods accept/return Map<String, dynamic> / primitives only —
the cubit owns the Model.fromJson(raw) conversion.

If this is an intentional refactor of an existing repo, mention it to the user
and they can override. Otherwise: move the .fromJson() call out of the repo
and return the raw Map.

See: docs/architecture/DECISIONS.md (ADR-013)
EOF
  exit 2
fi
exit 0
