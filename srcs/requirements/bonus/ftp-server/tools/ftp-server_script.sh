#!/bin/sh

if [ ! -f "/etc/vsftpd/vsftpd.conf.bak" ]; then

	mkdir -p /var/www/html

	mv /tmp/vsftpd.chroot_list /etc/vsftpd.chroot_list
	cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.bak
	mv /tmp/vsftpd.conf /etc/vsftpd/vsftpd.conf

	adduser $FTP_USER --disabled-password
	echo "$FTP_USER:$FTP_PWD" | /usr/sbin/chpasswd
	chown -R $FTP_USER:$FTP_USER /var/www/html
	chmod -R 755 /var/www/html

	echo $FTP_USER | tee -a /etc/vsftpd.userlist
	echo $FTP_USER | tee -a /etc/vsftpd.chroot_list

fi

/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
