FROM gcr.io/cloud-builders/gcloud-slim
WORKDIR /workspace
RUN add-apt-repository -y ppa:deadsnakes/ppa && \ 
  apt-get -y update && \
  apt-get -y install python3.7 && \
  rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir virtualenv
COPY docker-coverage.sh /usr/local/bin/
ENTRYPOINT ["docker-coverage.sh"]
