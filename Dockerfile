FROM gcr.io/google.com/cloudsdktool/cloud-sdk:latest
WORKDIR /workspace
RUN apt-get -y update && \
  apt-get -y upgrade && \
  apt-get -y install software-properties-common && \
  add-apt-repository -y ppa:deadsnakes/ppa && \
  apt-get -y install python3.7 && \
  rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir setuptools && pip install --no-cache-dir virtualenv
COPY docker-coverage.sh /usr/local/bin/
COPY requirements-test.txt /requirements-test.txt
ENTRYPOINT ["docker-coverage.sh"]
