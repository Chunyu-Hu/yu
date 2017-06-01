
# echo -n | openssl s_client -connect bugzilla.xxxx.com:443 2>&1 | grep issuer
#issuer=/C=US/O=DigiCert Inc/OU=www.digicert.com/CN=DigiCert SHA2 High Assurance
#Server CA

#Import CA certs:
# cd /etc/pki/ca-trust/source/anchors/
# wget https://password.corp.redhat.com/legacy.crt
# wget https://password.corp.redhat.com/RH-IT-Root-CA.crt
# update-ca-trust force-enable
# update-ca-trust extract

# Download whole directory, not html files. like ftp download.
wget -q -c -r -np -k -L -nH -E --reject html http://ibm-x3250m4-03.rhts.eng.pek2.redhat.com/uapi_sysctl/2.6.32-642.el6-2.6.32-693.el6/
wget -q -c -r -np -k -L -nH -E --reject html --cut-dirs 1 -P $mnt_tmpdir ${http_link}/

