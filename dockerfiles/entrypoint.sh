#!/bin/bash
######################################################################
# Initialize access credentials for development.
######################################################################

set -o errexit
set -o pipefail
set -o nounset

USERNAME="developer"
RANDOM_PASSWORD_LENGTH=30

log_info() {
	echo "INFO: $1"
}

log_error() {
	echo "ERROR: $1" >&2
}

if [ -z "${AUTHORIZED_KEYS:+x}" ]; then
	log_error "No authorized keys detected!"
	exit 1
fi

if [ -z "${PASSWORD:+x}" ]; then
	PASSWORD=$(tr -dc _A-Z-a-z-0-9 < /dev/urandom \
		| fold -w $RANDOM_PASSWORD_LENGTH \
		| head -n 1 || true)
	if [ "${#PASSWORD}" -ne $RANDOM_PASSWORD_LENGTH ]; then
		log_error "Failed to generate password"
		exit 1
	fi
fi
if ! id $USERNAME 2>/dev/null; then
	log_info "Creating user account..."
	echo -e "${PASSWORD}\n${PASSWORD}" \
		| adduser $USERNAME -h "$HOME" -u "$UID" -s /bin/bash \
		>/dev/null
	addgroup $USERNAME sudo
fi

if [ ! -d "${HOME}/.ssh" ]; then
	log_info "Installing authorized keys..."
	mkdir -p "${HOME}/.ssh"
	chown "${UID}:${UID}" "${HOME}/.ssh"
	chmod 0700 "${HOME}/.ssh"
	echo -n "$AUTHORIZED_KEYS" > "${HOME}/.ssh/authorized_keys"
	chown "${UID}:${UID}" "${HOME}/.ssh/authorized_keys"
	chmod 0600 "${HOME}/.ssh/authorized_keys"
fi

log_info "Generating server keys..."
[ -f /etc/ssh/ssh_host_rsa_key ] \
	|| ssh-keygen -q -t rsa -f /etc/ssh/ssh_host_rsa_key -C '' -N ''
[ -f /etc/ssh/ssh_host_ecdsa_key ] \
	|| ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -C '' -N ''
[ -f /etc/ssh/ssh_host_ed25519_key ] \
	|| ssh-keygen -q -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -C '' -N ''

#log_info "Creating privilege separation directory for OpenSSH..."
#if [ ! -d /run/sshd ]; then
	#mkdir /run/sshd
	#chmod 0755 /run/sshd
#fi

log_info "Starting sshd..."
exec tini -- $(which sshd) -D -e $@
