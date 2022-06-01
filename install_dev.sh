#!/bin/bash
### Python Setup. Assumes pyenv is installed with python 3.10.4 compiled and available

# Ensure we use correct python version for venv creation
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
pyenv shell 3.10.4
echo "Using $(python --version)"

echo "Creating virtual environment in .venv"
python -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
echo "Installing dev dependencies to virtual environment..."
# NOTE: see https://stackoverflow.com/a/20720019 for the approach below
python -m pip install -r install/requirements/dev.txt

