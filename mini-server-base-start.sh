#!/bin/sh

# Enable ssh if specified on docker run

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
# RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# FOR LOCAL ENVIRONMENT ONLY
if [ $(env | grep ENABLE_SSH) = "ENABLE_SSH=true" ];
	then
	if [ ! -z "$SSH_USERNAME" ]; then sshuname=$SSH_USERNAME; else sshuname=root; fi;
	if [ ! -z "$SSH_PASSWORD" ]; then sshpass=$SSH_PASSWORD; else sshpass=password; fi;
	apk add -U openssh;
	rc-update add sshd;
	echo "${sshuname}:${sshpass}" | chpasswd;
	sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config;
	mkdir -p /root/.ssh/ && touch /root/.ssh/authorized_keys;
fi
/usr/bin/mysql_install_db --user=mysql --ldata=/sql
rc-update add mysql default
mysqld --skip-grant-tables --user=root --datadir='/sql' &
/usr/sbin/apachectl -D FOREGROUND
# END LOCAL ONLY

# Start memcache
# /usr/bin/memcached -u memcache -v/usr/bin/mysql_install_db --user=mysql --ldata=/sql && \