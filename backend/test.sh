#!/usr/bin/env bash
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
PROJECT="$(dirname "$SCRIPT_DIR")"
PYTHON=$PROJECT/.venv/bin/python

cd "$SCRIPT_DIR" || exit 1
if [ ! -f $PROJECT/backend/testdb.sqlite3 ]; then
    echo "Test DB not found. Copying existing DB for testing..."
    cp $PROJECT/backend/db.sqlite3 $PROJECT/backend/testdb.sqlite3
fi

$PYTHON "manage.py" test --keepdb

