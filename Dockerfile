FROM gcr.io/cloud-builders/gcloud-slim
WORKDIR /workspace
RUN add-apt-repository -y ppa:deadsnakes/ppa && \ 
  apt-get -y update && \
  apt-get -y install python3.7
RUN pip install virtualenv
COPY docker-coverage.sh /usr/local/bin/
ENTRYPOINT ["docker-coverage.sh"]
