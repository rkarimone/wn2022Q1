

# Debian/Ubuntu

apt update
apt install postfix		// Select Satellite System
apt install -y libsasl2-modules mailutils

# dpkg-reconfigure postfix	// Select Satellite System

cd /etc/postfix/
cp main.cf orig.main.cf
vim main.cf

# Debian specific:  Specifying a file name will cause the first
#myorigin = /etc/mailname

smtpd_banner = $myhostname ESMTP $mail_name (Ubuntu)
biff = no
append_dot_mydomain = no
readme_directory = no
compatibility_level = 2

# TLS parameters
smtpd_tls_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
smtpd_tls_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
smtpd_tls_security_level=may

smtp_tls_CApath=/etc/ssl/certs
smtp_tls_security_level=may


smtpd_relay_restrictions = permit_mynetworks permit_sasl_authenticated defer_unauth_destination
myhostname = sarkarim
alias_maps = hash:/etc/aliases
alias_database = hash:/etc/aliases
mydestination = sarkarim, sarkarim, localhost.localdomain, localhost
mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128
mailbox_size_limit = 0
recipient_delimiter = +
inet_interfaces = loopback-only
inet_protocols = ipv4


##########
relayhost = email.domain1.com:587
smtp_use_tls = yes
smtp_sasl_auth_enable = yes
smtp_sasl_security_options =
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_tls_CAfile = /etc/ssl/certs/Entrust_Root_Certification_Authority.pem
smtp_tls_session_cache_database = btree:${data_directory}/smtp_scache
smtp_tls_session_cache_timeout = 3600s


echo "email.domain1.com hosting@domain1.com:PassWordSecret" > /etc/postfix/sasl_passwd
postmap hash:/etc/postfix/sasl_passwd
chmod 600 /etc/postfix/sasl_passwd
postfix reload

echo "ZFS REPLICATION OK" | mail -s "sebpo alert message test" -a "From: address@domain1.com" anotheraddr@domain2.com

mailq
tail -f /var/log/mail.log


echo "ZFS REPLICATION OK" | mail -s "sebpo alert message test" -a "From: address@domain1.com" anotheraddr@domain2.com






export REPLYTO=to@example.com
mail -aFrom:from@example.com -s 'Testing'




https://www.linuxtopic.com/2021/05/configure-postfix-as-smtp-relay.html
https://www.howtoforge.com/tutorial/configure-postfix-to-use-gmail-as-a-mail-relay/
https://kifarunix.com/configure-postfix-to-use-gmail-smtp-on-centos-8/
https://www.devopszones.com/2020/03/how-to-send-mail-through-gmail-on.html
https://netcorecloud.com/tutorials/install-centos-postfix/


