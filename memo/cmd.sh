
# echo -n | openssl s_client -connect bugzilla.xxxx.com:443 2>&1 | grep issuer
#issuer=/C=US/O=DigiCert Inc/OU=www.digicert.com/CN=DigiCert SHA2 High Assurance
#Server CA

#Import CA certs:
# cd /etc/pki/ca-trust/source/anchors/
# wget https://password.corp.redhat.com/legacy.crt
# wget https://password.corp.redhat.com/RH-IT-Root-CA.crt
# update-ca-trust force-enable
# update-ca-trust extract
