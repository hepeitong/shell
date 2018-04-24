#!/bin/bash
# write by yangbk,for check hardware health
# www.361way.com <itybku@139.com>

#######################################################
# 146 147 148 三框ping不通，需要登录到BI跳板机上操作
######################################################

Ciscoblade () {
IPs='''
10.212.186.48
10.212.186.51
200.200.0.102
200.200.0.105
'''
for IP in $IPs;do
    echo $IP
    echo "========================================="
    sshpass -p'*IK<0okm' ssh -o StrictHostKeyChecking=no admin@$IP 'show service-profile status' 
done

}

IBMblade () {
   cat inventory/IBMblade.txt|while read IP USERNAME PASSWORD
   do 
      echo $IP
      echo "========================================="
      sshpass -p$PASSWORD ssh -o StrictHostKeyChecking=no $USERNAME@$IP 'health -l all' < /dev/null
   done
}

hpblade () {
for OAIP  in  `cat inventory/hpblade.txt`;do
    echo $OAIP
    echo "========================================="
    sshpass -p'mypassword' ssh -o StrictHostKeyChecking=no admin@$OAIP 'show server status all'|grep -i Health
    echo
    done

    echo '10.211.58.171'
    sshpass -p'password01' ssh -o StrictHostKeyChecking=no admin@10.211.58.171 'show server status all'|grep -i Health
    
    echo '10.212.225.188'
    sshpass -p'password01' ssh -o StrictHostKeyChecking=no admin@10.212.225.188 'show server status all'|grep -i Health

    echo '10.212.239.81'
    sshpass -p'password03' ssh -o StrictHostKeyChecking=no admin@10.212.239.81 'show server status all'|grep -i Health
}



hppchealth () {
  cat inventory/hppc.txt|while read IP USERNAME PASSWORD
  do
      echo $IP
      echo "========================================="
      ipmitool -I lanplus  -H $IP -U$USERNAME -P$PASSWORD sdr list|grep -v disabled
      echo  
  done
}



############################################################
  # for ipmihealth fun
  # $1 hostname file
  # $2 open/lan/lanplus
  # $3 username
  # $4 password
  # you can use `grep -v ok  log.txt|less` find error info
############################################################

ipmihealth () {

  for IP in `cat inventory/$1`;do
     echo $IP
     echo "========================================="
     ipmitool -I $2  -H $IP -U$3 -P$2 sdr list
     echo 
  done
}

echofile () {
  echo "# 生成日期 `date +%Y%m%d`" > logs/IBM_BLADE.txt 
  echo "# 生成日期 `date +%Y%m%d`" > logs/HP_BLADE.txt
  echo "# 生成日期 `date +%Y%m%d`" > logs/HP_PC.txt
  echo "# 生成日期 `date +%Y%m%d`" > logs/IBM_PC.txt
  echo "# 生成日期 `date +%Y%m%d`" > logs/Huawei.txt 
  echo "# 生成日期 `date +%Y%m%d`" > logs/DELL.txt
  echo "# 生成日期 `date +%Y%m%d`" > logs/Inspur.txt
  echo "# 生成日期 `date +%Y%m%d`" > logs/Cisco_BLADE.txt

}

cd /usr/local/health
rm -rf logs/*.txt
echofile
IBMblade >> logs/IBM_BLADE.txt
hpblade >> logs/HP_BLADE.txt
hppchealth >> logs/HP_PC.txt 2>&1
ipmihealth 'ibmpc.txt' open  USERID  PASSW0RD >> logs/IBM_PC.txt 2>&1 
ipmihealth 'huawei.txt' open  root  'Huawei12#$' >> logs/Huawei.txt 2>&1 
ipmihealth 'dell.txt' open  root  calvin >> logs/DELL.txt 2>&1 
ipmihealth 'inspur.txt' open  admin  admin >> logs/Inspur.txt 2>&1 

Ciscoblade >> logs/Cisco_BLADE.txt

# 最后可以增加下把这些txt生成的文件，放到webserver目录下，并开启index索引查看。
