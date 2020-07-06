
# OneKey-CentOS 7 无证书 kcptun V2Ray-mkcp 
{

######################################################################################################
{
# 先关闭selinux和防火墙，安装基本的工具包
systemctl stop firewalld.service #停止firewall
systemctl disable firewalld.service #禁止firewall开机启动
setenforce 0
sed -i '/SELINUX=/s/^/# /'  /etc/selinux/config
echo  "SELINUX=disabled" >> /etc/selinux/config

yum install -y  wget curl nano vsftpd unzip 
touch /Cron  &&  chmod 4755 /Cron
mkdir /www
# mkdir /dd

# vsftpd设置，在ftpusers 和 user_list 文件中注释掉root行，以便root账户连接。
 sed -i '/root/s/^/# /'  /etc/vsftpd/ftpusers
 sed -i '/root/s/^/# /'  /etc/vsftpd/user_list

# 修改配置文件，解决550和530 Permission denied 错误 
 sed -i '/write_enable/s/^/# /'  /etc/vsftpd/vsftpd.conf  
 echo  "write_enable=YES" >>  /etc/vsftpd/vsftpd.conf  
 sed -i '/userlist_enable/s/^/# /'  /etc/vsftpd/vsftpd.conf  
 echo  "userlist_enable=NO" >>  /etc/vsftpd/vsftpd.conf  
 systemctl daemon-reload  &&  systemctl enable vsftpd
 systemctl restart vsftpd
}
####################################################################





######################################################################################################
# VPS每天定时重启。
{
timedatectl set-timezone Asia/Singapore  # 修改时区为新加坡，东8区。

 sed -i '/date/s/^/# /'  /etc/crontab
 echo -e "0 4 * * * root date  >> /Cron 2>&1"  >>  /etc/crontab
 sed -i '/reboot/s/^/# /'  /etc/crontab
 echo -e "0 4 * * * root reboot  >> /Cron 2>&1"  >>  /etc/crontab
}
####################################################




######################################################################################################
{
# BBR 开启命令 用了锐速lotServer就不需要BBR
# sed -i '/net.core.default_qdisc/s/^/# /'  /etc/sysctl.conf  
# sed -i '/net.ipv4.tcp_congestion_control/s/^/# /'  /etc/sysctl.conf  
# echo  "net.core.default_qdisc = fq" >> /etc/sysctl.conf
# echo  "net.ipv4.tcp_congestion_control = bbr" >> /etc/sysctl.conf

# 测试bbr
sysctl net.ipv4.tcp_available_congestion_control && sysctl net.ipv4.tcp_congestion_control && lsmod | grep bbr  &&  sysctl net.core.default_qdisc
}
#############################################################




######################################################################################################
{
#V2fly 手动安装新官方V2Ray   #  nano  /v2fly/config.json  
sleep 1
rm -fR /v2fly  &&  mkdir /v2fly  &&  cd /v2fly  
# 提取版本号，用awk搭配grep万能。grep定位关键词所在行。awk -F 后面为分隔符 NR==1为第1行 print显示分隔出第个数据。 # 第二个下载wget中要用双引号。单引号'强转义，不下载，$变量不执行。
v2fly_ver=$(wget --no-check-certificate -O- "https://github.com/v2fly/v2ray-core/releases" | grep 'v2fly/v2ray-core/releases/download' | grep 'linux-64' | awk -F '"' 'NR==1 {print $2}' )   &&  echo "${v2fly_ver}"
wget --no-check-certificate "https://github.com${v2fly_ver}" 
unzip *.zip

# V2fly centos7 加入开机启动自启。 用 /etc/rc.d/rc.local 方法。
sed -i '/v2ray/s/^/# /'  /etc/rc.d/rc.local  
echo  "/v2fly/v2ray -config /v2fly/config.json"  >>  /etc/rc.d/rc.local  
chmod +x  /etc/rc.d/rc.local 
}  
#####################################################




######################################################################################################
{
# kcptun手动安装官方。获取最新版本号逗比https://doubibackup.com/z2a4lk3l-3.html这个方法太笨，自己编。
sleep 1
rm -fR /kcp  &&  mkdir /kcp  &&  cd /kcp  
# 用awk搭配grep万能。grep定位关键词所在行。awk -F 后面为分隔符 NR==1为第1行 print显示分隔出第个数据。
kcp_ver=$(wget --no-check-certificate -O- "https://github.com/xtaci/kcptun/releases" | grep 'xtaci/kcptun/releases/download' | grep 'linux-amd64' | awk -F '"' 'NR==1 {print $2}' )  &&  echo "${kcp_ver}"
wget --no-check-certificate "https://github.com${kcp_ver}"  # 要用双引号。单引号'强转义，不下载，$变量不执行。
tar -xf  *.gz

# kcp自启服务文件 https://zorz.cc/post/install-shadowsocks-by-compiled.html
cat > /etc/systemd/system/kcp.service << \EOF  
[Unit]
Description=kcp server
After=network.target
[Service]
ExecStart=/kcp/server_linux_amd64 -c  /kcp/server-config.json
ExecStartPost=/bin/sleep 0.1
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF
chown -R root:root  /kcp
# chmod  -R  4755  /kcp  /etc/systemd/system/kcp.service
systemctl daemon-reload  &&  systemctl enable kcp.service
## kcp安装结束
}
###########################################################




######################################################################################################
{
# 创建V2ray 配置文件  systemctl restart v2ray  #  systemctl status v2ray  
# V2ray配置文件内容    >为清空写入。>>为追加。 nano  /v2fly/config.json    
  cat >  /v2fly/config.json  <<  EOF
{"inbounds":[{"port":200,"protocol":"shadowsocks","settings":{"method":"chacha20-ietf-poly1305","ota":false,"password":"ohqmima7","network":"tcp,udp"}},{"port":554,"protocol":"vmess","settings":{"clients":[{"id":"443bcb0a-7fe9-462c-a355-8484baaab6d0","alterId":64}]},"streamSettings":{"network":"kcp","kcpSettings":{"seed":"henbaoli","tti":20,"uplinkCapacity":100,"downlinkCapacity":100,"congestion":false,"readBufferSize":2,"writeBufferSize":2}}}],"outbounds":[{"protocol":"freedom","settings":{}},{"protocol":"blackhole","settings":{},"tag":"blocked"}],"routing":{"rules":[{"type":"field","ip":["geoip:private"],"outboundTag":"blocked"}]}}

EOF

# KCPtun配置文件 nano /kcp/server-config.json  #  systemctl restart kcp  #  systemctl status kcp
cat >  /kcp/server-config.json  << EOF
{"listen":":3389","target":"127.0.0.1:200","key":"henbaoli","crypt":"salsa20","mtu":1350,"sndwnd":8192,"rcvwnd":8192,"datashard":37,"parityshard":21,"nocomp":true,"dscp":46,"acknodelay":false,"mode":"fast"}

EOF
}
################################################################

}
# 一个回车结束


