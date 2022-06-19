#!/usr/bin/env bash
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
PROJECT="$(dirname "$SCRIPT_DIR")"
PYTHON=$PROJECT/.venv/bin/python

cd "$SCRIPT_DIR" || exit 1
$PYTHON "manage.py" makemigrations && $PYTHON "manage.py" migrate


