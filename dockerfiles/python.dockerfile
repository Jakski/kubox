ARG PYTHON_VERSION=3.6
FROM python:${PYTHON_VERSION}-alpine3.8 as python

FROM kubox:base
RUN apk add --no-cache \
	coreutils \
	linux-headers \
	dpkg \
	expat \
	findutils \
	gdbm \
	libffi \
	libnsl \
	libressl \
	libtirpc \
	ncurses \
	pax-utils \
	readline \
	sqlite \
	tcl \
	tk \
	xz
COPY --from=python /usr/local/ /usr/local/
