FROM alpine:3.8

RUN apk add --no-cache \
	ncurses \
	openssh \
	neovim \
	sudo \
	bash \
	tini \
	ca-certificates \
	&& addgroup -S sudo \
	&& sed -i 's/# \(%sudo[\t\s]\+.*\)/\1/' /etc/sudoers \
	&& mv /etc/profile.d/color_prompt /etc/profile.d/color_prompt.sh

COPY ./entrypoint.sh /usr/bin/entrypoint.sh
COPY ./sshd_config /etc/ssh/sshd_config
RUN chown root:root /etc/ssh/sshd_config /usr/bin/entrypoint.sh \
	&& chmod 0644 /etc/ssh/sshd_config

ENV UID=1000
ENV HOME=/home/developer
ENV KEY_DIR=/srv/ssh

VOLUME $KEY_DIR
VOLUME $HOME

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
