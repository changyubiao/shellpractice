#########################################################################
# File Name: check_server.sh
# Author:biaoge
# mail:15769162764@163.com
# Created Time: 2016年09月28日 星期三 00时47分29秒
#########################################################################
#!/bin/bash
#Program function: To check nginx and mysql's running status. 
Resettem=$(tput sgr0)
Nginxserver='http://www.test.com/forum.php'

##check last command is OK or not.
check_ok() {
if [ $? != 0 ]
then
    echo "Error, Check the error log."
    exit 1
fi
}

##if the packge installed ,then omit.
myum() {
if ! rpm -qa|grep -q "^$1-[0-9]." 
then
    yum install -y $1
    check_ok
else
    echo $1 already installed.
fi
}

Check_Nginx_Server()
{
    Status_code=`curl -m 5 -s -w %{http_code} ${Nginxserver} -o /dev/null`
#    echo  $Status_code
    if [ $Status_code -eq 000 -o  $Status_code -ge 500 ]
    then 
        echo -e '\E[32m' "check http server error! Response status code is " $Resettem  $Status_code
    else 
        Http_content=$(curl -s ${Nginxserver})     
        echo -e '\E[32m' "check http server ok! Response status code:"  $Resettem  $Status_code
      
    fi
    
  
}
#
Mysql_Slave_Server='192.168.57.130'
Mysql_User='rep'
Mysql_Pass='imooc'

myum nc
Check_Mysql_Server()
{
   #检查端口 3306 是否打开
   nc -z -w2   ${Mysql_Slave_Server} 3306 &>/dev/null 
   #nc -z -w2  192.168.57.130  3306
   if [ $? -eq 0 ]
   then
      echo -e '\E[32m' "Connect ${Mysql_Slave_Server} Ok." $Resettem
#      /usr/local/mysql/bin/mysql  -u${Mysql_User} -p${Mysql_Pass} -h${Mysql_Slave_Server} -e "show slave status\G"|grep -w 'Slave_IO_Running'|awk '{ if($2!="Yes"){print "Slave thread is not running!"; exit 1} }'

      IO_Stauts=$(/usr/local/mysql/bin/mysql  -u${Mysql_User} -p${Mysql_Pass} -h${Mysql_Slave_Server} -e "show slave status\G"|grep -w 'Slave_IO_Running'|awk '{print $2}') 
      #echo  $IO_Stauts
      if [ "$IO_Stauts" = "No" -o   "$IO_Stauts" = "NO" ]
      then 
          echo -e '\E[32m'  "Slave thread is not running!"  $Resettem
      else 
          Seconds_Behind_Master=$( mysql -u${Mysql_User} -p${Mysql_Pass} -h${Mysql_Slave_Server} -e "show slave status\G"|grep -iw 'Seconds_Behind_Master' |sed  's/ //g')
          echo -e '\E[32m' "$Seconds_Behind_Master"  $Resettem 
      fi     
      
   else 
      echo -e '\E[32m' " Conection Mysql_Server  Failed" $Resettem
  
   fi
}




Check_Nginx_Server
Check_Mysql_Server
