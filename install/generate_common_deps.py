from pathlib import Path
from subprocess import run

INSTALL_ROOT = Path(__file__).resolve().parent
DEV_DEPS = INSTALL_ROOT / "requirements/dev.txt"
COMMON_DEPS = INSTALL_ROOT / "requirements/common.txt"
VENV = INSTALL_ROOT.parent / ".venv"
PIP = VENV / "bin/pip"  # no one has Windows, this is fine

if __name__ == "__main__":
    with open(DEV_DEPS, "r") as handle:
        dev_deps = handle.readlines()[1:]
    # remove trailing whitespace
    dev_deps = [dep.strip() for dep in dev_deps]
    print(dev_deps)
    completed = run(args=f"{PIP} freeze", shell=True, check=True, capture_output=True)
    reqs = completed.stdout.decode().splitlines()

    if COMMON_DEPS.exists():
        COMMON_DEPS.unlink()
    with open(COMMON_DEPS, "w") as handle:
        for req in reqs:
            if req not in dev_deps:
                handle.write(f"{req}\n")
