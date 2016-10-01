#########################################################################
# File Name: monitor_man.sh
# Author:biaoge
# mail:15769162764@163.com
# Created Time: 2016年09月27日 星期二 18时52分56秒
#########################################################################
#!/bin/bash
resettem=$(tput  sgr0)
declare -A array
i=0
numbers=""
#for files in `ls -I "monitor_man.sh" "access.log" ./`
for files in `ls ./ |grep -vE  "^monitor_man.sh|^access.log" `
do
  echo -e "\e[1;35m"  "The Script:" ${i} '===>' ${resettem} ${files}
  grep -E "^\#Program function" ${files}
  array[$i]=${files}
  numbers="${numbers} |${i}"
  let "i= i+1"
done
#echo ${numbers}
while true
do
  read -p "Please input a number [ ${numbers} ]:"  number
  if [[ ! ${number} =~ ^[0-9]+ ]]
  then
      echo "your input error ." 
      echo "The program will  exit!"
      exit  0
  fi
  /bin/bash  ./${array[$number]}
done
