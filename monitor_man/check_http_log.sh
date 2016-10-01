#########################################################################
# File Name: check_http_log.sh
# Author:biaoge
# mail:15769162764@163.com
# Created Time: 2016年10月01日 星期六 11时18分25秒
#########################################################################
#!/bin/bash
#Program function:Nginx's log analysis
echo 
resettem=$(tput sgr0)
Logfile_path='./access.log'

Check_http_status()
{
#cat ./access.log | awk '{print $7}'|awk '{print $1}'

  Http_statu_codes=(`cat $Logfile_path | awk '{print $7}'|awk  '{
                    if( $1<100){
		      p++;
		    }
                    else if ($1>=100 &&$1<200)
	              { i++}
                    else if($1>=200&&$1<300)
                      { j++}
                    else if($1>=300&&$1<400)
                      { k++}
                    else if($1>=400&&$1<500)
                      { m++}
                    else if ($1>=500)
                     { n++}

                 }END{
                      print p?p:0, i?i:0,j?j:0, k?k:0, m?m:0,n?n:0,i+j+k+n+m+p
                }' 
 
                `) 


 echo -e '\E[33m' "The number of http status[100-]:" ${resettem} ${Http_statu_codes[0]}
 echo -e '\E[33m' "The number of http status[100+]:" ${resettem} ${Http_statu_codes[1]}
 echo -e '\E[33m' "The number of http status[200+]:" ${resettem} ${Http_statu_codes[2]}
 echo -e '\E[33m' "The number of http status[300+]:" ${resettem} ${Http_statu_codes[3]}
 echo -e '\E[33m' "The number of http status[400+]:" ${resettem} ${Http_statu_codes[4]}
 echo -e '\E[33m' "The number of http status[500+]:" ${resettem} ${Http_statu_codes[5]}
 echo -e '\E[33m' "All request numbers:"              ${resettem} ${Http_statu_codes[6]}

}


Check_Http_Code()
{
   Http_Code=(`cat ./access.log | awk '{print $7}'|awk -v total=0 '{
                 if($1!=""){
		   code[$1]++ ;
                   total++;
                 }
                 else
                 {  exit 1}
                   
                 }END{
                   print code[404]?code[404]:0 ,code[403]?code[403]:0,code[502]?code[502]:0, total 
                 }' 
             `)  
  echo "Detail infomation:"  
 echo -e '\E[33m' "The number of http code[403]:"   ${resettem} ${Http_Code[1]}
 echo -e '\E[33m' "The number of http code[404]:"   ${resettem} ${Http_Code[0]}
 echo -e '\E[33m' "The number of http code[502]:"   ${resettem} ${Http_Code[2]}
 echo -e '\E[33m' "All request numbers:"             ${resettem} ${Http_Code[3]}
  

}


Check_http_status
Check_Http_Code

