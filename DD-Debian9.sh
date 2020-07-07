
# Debian 全球重装 自动提取ip和网关地址 (ubuntu 为 -u 18.04)

apt-get update  &&  apt-get install -y wget xz-utils openssl gawk file net-tools screen
yum install -y xz wget openssl gawk file net-tools screen
IPv4="$(ip a | grep 'global' | grep -Eo "\b([0-9]{1,3}[\.]){3}[0-9]{1,3}\b" | sed -n '1p')"  &&  echo ${IPv4}
GATE="$(ip r | grep 'default via' | grep -Eo "\b([0-9]{1,3}[\.]){3}[0-9]{1,3}\b" | sed -n '1p')"  &&  echo ${GATE}
MASK="$(ifconfig | grep -Eo "\b([0-9]{1,3}[\.]){3}[0-9]{1,3}\b" | sed -n '2p')"  &&  echo ${MASK}
sleep 1
bash <(wget --no-check-certificate -qO- 'https://moeclub.org/attachment/LinuxShell/InstallNET.sh')  --ip-addr ${IPv4}  --ip-gate ${GATE}  --ip-mask ${MASK}  -v 64 -a  -d    9    
    #    
