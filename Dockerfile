FROM ubuntu
MAINTAINER ukatama dev.ukatama@gmail.com

RUN apt-get update -y -q

# Utilities
RUN apt-get install -y -q \
	wget

# Requirements at Run-time
RUN apt-get install -y -q \
	libssl1.0.0 \
	liblog4cplus-1.0-4 \
	libmysqld-dev \
	postgresql-server-dev-9.3

# Requirements at Build
RUN apt-get install -y -q \
	libboost-all-dev \
	liblog4cplus-dev \
	g++ \
	make

# Build and Install
RUN wget -q http://ftp.isc.org/isc/kea/1.0.0/kea-1.0.0.tar.gz
RUN tar xvf kea-1.0.0.tar.gz
RUN cd kea-1.0.0 && ./configure --with-dhcp-mysql --with-dhcp-pgsql
RUN cd kea-1.0.0 && make
RUN cd kea-1.0.0 && make install
RUN rm kea-1.0.0.tar.gz
RUN ldconfig

# Add Config
ADD ./etc /usr/local/etc/kea
RUN kea-dhcp4 -c /usr/local/etc/kea/kea.conf -W

ENTRYPOINT kea-dhcp4 -c /usr/local/etc/kea/kea.conf
