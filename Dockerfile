FROM dduportal/bats:0.4.0
LABEL Maintainer="https://github.com/pivotal-cf/pcf-pipelines"

COPY . /

RUN apt-get update &&   apt-get install -y jq

CMD ["/test"]
