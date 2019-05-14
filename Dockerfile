from ubuntu:xenial

# Set the locale
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8

# grab tools
RUN apt-get update && apt-get install -y wget gcc libreadline6 libreadline6-dev zlib1g-dev build-essential locales

RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN echo "LANG=en_US.UTF-8" > /etc/locale.conf
RUN locale-gen en_US.UTF-8

ENV BUILDER_HOME=/home/postgres
RUN useradd -s /bin/bash -m -d $BUILDER_HOME postgres
USER postgres

WORKDIR /home/postgres

COPY pg11.sh . 


CMD "bash"