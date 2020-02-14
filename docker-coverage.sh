#!/bin/bash
#
# - this entrypoint expect one argument: a directory which contains the root of a Python application
# - it expects this directory to contain a requirements-test.txt file
# - it will copy this directory to a tmpdir
# - install the test dependencies
# - and run the unittests using coverage from there, in a virtual env
#
set -eo pipefail
if [ "$BRANCH_NAME" == "master" ]; then
    echo "Skipping unittests in master branch due to missing prod user account"
    exit 0
fi
if [ "$1" == "" ]; then
    echo "This container expects one argument: a Python application directory "
    exit 1
fi
if [ -f "$1/requirements-test.txt" ]; then
    MYTEMP=$(mktemp -d -u)
    echo "Copying $1 to ${MYTEMP}"
    cp -ap $1 ${MYTEMP}
    cd ${MYTEMP}
    echo "Creating virtualenv"
    virtualenv -p python3.7 venv
    source venv/bin/activate
    echo "Running pip install -r requirements-test.txt"
    pip install -r requirements-test.txt
    export GOOGLE_CLOUD_PROJECT="${PROJECT_ID}"
    echo "Running coverage run -m unittest on ${PROJECT_ID}"
    coverage run -m unittest
    coverage report -m
else
    echo "Skipping unittesting due to missing $1/requirements-test.txt"
    exit 0
fi
