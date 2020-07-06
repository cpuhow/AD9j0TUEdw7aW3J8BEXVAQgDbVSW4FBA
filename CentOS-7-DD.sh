yum -y install wget
wget --no-check-certificate -O-  'https://www.googleapis.com/drive/v3/files/1jnNY7E8oH9CQmkbSCh4kdWElVWCuTwmL?alt=media&key=AIzaSyAMgpypCNDCQM_JmJRWfGwCmdl4yDANaJU' | gunzip | dd of=/dev/sda
