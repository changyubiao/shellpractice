#########################################################################
# File Name: system_monitor.sh
# Author:biaoge
# mail:15769162764@163.com
# Created Time: 2016年09月27日 星期二 19时21分53秒
#########################################################################
#!/bin/bash
#Program function: A Shell Script to Monitor Network, Disk Usage ,Uptime, Load Average and RAM Usage in Linux
clear
if [[ $# -eq 0 ]]
then 
   reset_terminal=$(tput  sgr0)
   #check OS Type 
   os=`uname -o`
   echo -e '\E[32m'"Operating System Type:" $reset_terminal  $os
   #check OS  Release Version an Name
   os_name=`cat /etc/issue|head -n 1`
   echo -e '\E[32m'"Release Version an Name:" $reset_terminal  $os_name
   #check Architecture
   architecture=$(arch)
   echo -e '\E[32m'"Architecture:" $reset_terminal  $architecture
   # uname -m 
   #check  Kernel Release
   kernelrelease=`uname -r`
   echo -e '\E[32m'"kernelrelease: " $reset_terminal  $kernelrelease
   #check hostname
    hostname=$(hostname)
   echo -e '\E[32m'"hostname: " $reset_terminal  $hostname
   #check Internal IP
    internalip=`hostname -I`
   echo -e '\E[32m'"Internal IP: " $reset_terminal  $internalip
   #check External IP
      #externalip=`curl ip.6655.com/ip.aspx` 
    externalip=`curl -s http://ipecho.net/plain`
   echo -e '\E[32m'"External IP: " $reset_terminal  $externalip
   #check DNS
    nameservers=` cat /etc/resolv.conf|grep -E "\<nameserver[ ]+"|awk '{print $NF}'`
   echo -e '\E[32m'"DNS: " $reset_terminal  $nameservers
   #check if connected to Internet or not
    ping -c 3  wwww.baidu.com &> /dev/null && echo "Internet: Connected" || echo "Internet:Disconnected"
   #check Logged In Users
    who >/tmp/who.txt 
    echo -e '\E[32m'"Logged In Users " $reset_terminal  && cat /tmp/who.txt
    rm -f  /tmp/who.txt

    #########################################
    system_mem_usages=$(awk '/MemTotal/{total=$2}  /MemFree/{free=$2}END{ print (total-free)/1024}'  /proc/meminfo)
   echo -e '\E[32m'"system_mem_usages: " $reset_terminal  $system_mem_usages

    app_mem_usages=$( awk '/MemTotal/{total=$2}  /MemFree/{free=$2}/^Cached/{cache=$2} /Buffers/{buffer=$2} END{print (total-free-cache-buffer)/1024}'  /proc/meminfo)

   echo -e '\E[32m'"app_mem_usages: " $reset_terminal  $app_mem_usages
   
    load_average=$(top -n1 -b|grep ' load average'|awk '{print $10 $11 $12}')
   echo -e '\E[32m'"load_average: " $reset_terminal  $load_average
    disk_average=$(df -Ph |sed '1d'|grep -Ev 'tmpfs'|awk '{print $1"   " $5" "}')
   echo -e '\E[32m'"disk_average: " $reset_terminal  $disk_average
fi

