#!/usr/bin/env bash
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
PROJECT="$(dirname "$SCRIPT_DIR")"
PYTHON=$PROJECT/.venv/bin/python

$PYTHON "$PROJECT/backend/manage.py" test --keepdb

