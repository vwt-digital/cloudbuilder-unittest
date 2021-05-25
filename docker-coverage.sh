#!/bin/bash
#
# - this entrypoint expect one argument: a directory which contains the root of a Python application
# - it expects this directory to contain a requirements.txt file
# - it will copy this directory to a tmpdir
# - install the (test) dependencies
# - and run the unittests using coverage from there, in a virtual env
#
set -eo pipefail
if [ "$BRANCH_NAME" == "master" ]; then
    echo "Skipping unittests in master branch due to missing prod user account"
    exit 0
fi
if [ "$1" == "" ]; then
    echo "This container expects one argument: a Python application directory. Failing..."
    exit 1
fi
if [ -f "$1/requirements.txt" ]; then
    MYTEMP=$(mktemp -d -u)
    echo "Copying $1 to ${MYTEMP}"
    cp -ap "$1" "${MYTEMP}"
    echo "Copying test requirements to ${MYTEMP}"
    cp /requirements-test.txt "${MYTEMP}"
    cd "${MYTEMP}"
    echo "Creating virtualenv"
    virtualenv -p python3.7 venv
    # shellcheck disable=SC1091
    source venv/bin/activate
    echo "Installing requirements"
    pip install -r requirements.txt
    pip install -r /requirements-test.txt
    export GOOGLE_CLOUD_PROJECT="${PROJECT_ID}"
    export API_KEY="$TEST_API_KEY"
    echo "TEST_API_KEY: $TEST_API_KEY"
    echo "API_KEY: ${API_KEY}"
    echo "Running coverage run -m unittest on ${PROJECT_ID}"
    coverage run -m unittest
    coverage report -m
else
    echo "$1/requirements.txt was not found. Failing..."
    exit 1
fi
