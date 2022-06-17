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

To confirm installation was successful, run

```bash
npm run build_test
npm test frontend/tests/test.test.ts
bash /backend/test.sh
```

The first command should compile the `.tsx` files in `frontend/apps/test_app` and place the compiled
`.js` file in `backend/static/js/test_app`. The second command ensure Jest and `ts-jest` are correctly
setup and that a minimal test passes, with coverage information. The final command runs Django tests.

## Testing

### Frontend

Frontend tests can be run with `npm test`.

### Backend

Django tests can be run with using the shortcut script with

`./backend/test.sh`

or manually with `python backend/manage.py test --keepdb` (after ensuring the `.venv`
has been activated).

## Dependencies

If you introduce new non-development, backend dependencies, you should run

```sh
python install/generate_common_deps.py
```

to update the common dependencies. New backend *development* dependencies must be added manually to
`install/requirements/dev.txt`.