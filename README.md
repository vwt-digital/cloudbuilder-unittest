# Cloudbuilder-unittest

This container allows us to run unittests using `coverage` on our Python 3.7 code with support for Google Cloud Platform environments.

## Prerequisites

1. A Python (API) project/repository.
1. Tests that:
    - use the `unittest` Python module
    - are autodiscoverable through their file naming (e.g. `api_server/openapi_server/test/test_blah.py`)
    - are runnable from the application root. For VWT this is the `api_server/` directory most of the time. Note that the application root is different from the project/repository root.
1. A `requirements-test.txt` file that also includes these Python modules:
    - `Flask-Testing`
    - `coverage`

## Usage

One argument is required to run this container: the root directory of a Python application that contains the `requirements-test.txt` file. For most of our projects this would be the `api_server` subdirectory of a Python project.

Typically this container would run as a custom build step in a Cloud Build pipeline after preparing a deployment directory, but before actually deploying it to Google App Engine.

It will copy the provided directory into a temporary directory to run the test in and install dependencies, so it will not pollute the original directory.

```
# Run python unittests
- name: 'eu.gcr.io/vwt-d-gew1-dat-cloudbuilders/cloudbuilder-unittest'
  args: ['/workspace/my_api_dir/api_server']
  env:
    - PROJECT_ID=$PROJECT_ID
```

Or locally on a dev laptop with /workspace as a mounted volume for some local directory:

```
docker run -v /Users/user01/git/myapp:/workspace -ti cloudbuilder-unittest /workspace/api_server
```

## Testing

This project uses the Google Container Structure Test with a number of tests included in `test_config.yaml`. This is part of a custom build step in Cloud Builder.
