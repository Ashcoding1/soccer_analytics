# soccer_analytics
An analysis of European soccer games.

# Development

Note development on Windows is currently not supported.

To install, you must first have `pyenv` installed, and have run `pyenv install Python 3.10.4` once
to make the correct Python version available. Then, clone this repository, `cd` to the cloned directory,
and run:

```bash
bash install_dev.sh
```

Django tests can be run with [...]. Jest tests can be run with [...]

If you introduce new non-development dependencies, you should run

```sh
python install/generate_common_deps.py`
```

to update the common dependencies. New development dependencies must be added manually to
`install/requirements/dev.txt`.