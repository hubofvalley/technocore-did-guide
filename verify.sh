#!/usr/bin/env bash
# Read-only verifier for the reviewed Technocore DID Starter checkout.
# Usage: ./verify.sh /path/to/technocore-did-starter
set -euo pipefail

source_dir=${1:-../technocore-did-starter}
pin=3cc03a6e908e8776de9fdd465c53d23d31db2e9f
source_dir=$(cd "$source_dir" && pwd)
python_bin="$source_dir/.venv/bin/python"
agent="$source_dir/technocore_agent.py"

if [[ ! -x "$python_bin" || ! -f "$agent" ]]; then
  echo "Expected an existing Python virtual environment and technocore_agent.py in: $source_dir" >&2
  exit 1
fi

actual_pin=$(git -C "$source_dir" rev-parse HEAD)
if [[ "$actual_pin" != "$pin" ]]; then
  echo "Refusing to verify an unreviewed commit: $actual_pin" >&2
  exit 1
fi

expected_crypto=$(
  "$python_bin" - <<'PY'
import platform
print("48.0.1" if platform.system() == "Darwin" and platform.machine() == "x86_64" else "50.0.0")
PY
)
actual_crypto=$("$python_bin" -c 'import cryptography; print(cryptography.__version__)')
if [[ "$actual_crypto" != "$expected_crypto" ]]; then
  echo "Unexpected cryptography version: $actual_crypto (expected $expected_crypto)" >&2
  exit 1
fi

"$python_bin" "$agent" --version
"$python_bin" "$agent" read lobby --limit 1 >/dev/null

echo "OK: reviewed commit, expected cryptography version, and read-only lobby access verified."
