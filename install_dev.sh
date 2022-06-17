#!/bin/bash
set -e  # exit on error
### Python Setup. Assumes pyenv is installed with python 3.10.4 compiled and available

# Ensure we use correct python version for venv creation
if ! command -v pyenv &> /dev/null
then
    echo "Error: command \`pyenv\` could not be found"
    exit 1
fi

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

if ! command -v nvm &> /dev/null
then
    echo "Error: command \`nvm\` could not be found"
    exit 1
fi
# node setup. Assumes nvm (Node version manager) is installed and available on your PATH
nvm install v16.15.0 --lts
nvm use v16.15.0
npm update -g npm
npm ci  # intall from package-lock.json only: can change to npm install if Linux/MacOS issues

bash import_data.sh