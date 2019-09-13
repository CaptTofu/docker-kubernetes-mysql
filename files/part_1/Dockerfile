FROM mysql:8.0.17
ENV DEBIAN_FRONTEND=noninteractive
COPY .vimrc /root/.vimrc
RUN apt-get update
RUN apt-get install -y net-tools less vim psutils