# Set default values for all following accounts.

defaults
logfile ~/.msmtp.log

# Red Hat account
account XxxXxx 
host smtp.corp.xxxxxx.com
from xx@redhat.com
user xx@redhat.com

# Set a default account
account default : RedHat

# ~/.msmtprc
