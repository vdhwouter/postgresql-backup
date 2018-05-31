FROM registry.access.redhat.com/rhscl/postgresql-95-rhel7

LABEL maintainer="wouter.vandenheede@axians.com"

ENV BACKUP_DATA_DIR="/tmp" \
    BACKUP_KEEP="2" \
    BACKUP_MINUTE="*" \
    BACKUP_HOUR="*"

USER root

# update system
RUN yum -y update && \

# install packages
    yum -y install \
        python-devel \
        mercurial \
        wget && \

# install epel-release rpm
    wget https://fedora.cu.be/epel//epel-release-latest-7.noarch.rpm -P /tmp && \
    rpm -Uvh /tmp/epel-release-latest-7.noarch.rpm && \

# install python-pip
    yum -y install \
        python-pip && \
    pip install --upgrade pip && \

# install dev cron
    pip install -e hg+https://bitbucket.org/dbenamy/devcron#egg=devcron && \

# cleanup
    yum clean all && \
    rm -rf \
        /tmp/*

WORKDIR /opt/app-root/src

ADD run.sh job.sh bin/

USER 1001

CMD /opt/app-root/src/bin/run.sh
