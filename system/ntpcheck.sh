#!/bin/bash
# power by www.361way.com
# 检查总部dns信息是否更新
# 检查总部DNS和本地DNS获取的结果是否相同

function sendsms() 
{
phonenums='
138111111111
139111111111
'
cd /usr/local/notice

for phone in $phonenums;do 
    python sms.py $phone  $1
    sleep 1
done
}


mgdns=`host -4 ns.migu.cn | awk '{print $NF}' `
if [[ $mgdns != "218.200.160.91" ]]; then
        echo "总部dns已经更换了！"
fi

localdns='192.168.27.59
192.168.27.60
192.168.27.61
192.168.44.33
192.168.44.34
10.125.41.58
10.125.41.59
'
for ldns in $localdns;do 
        name1=`dig @$ldns passport-ip.migu.cn +short`
        name2=`dig @$mgdns passport-ip.migu.cn +short`
        echo $name1 $name2 
        if [[ $name1 != $name2 ]]; then
                echo "passport-ip.migu.cn 已经变化，$ldns 获取的值不正确，请进行检查"
                sendsms "passport-ip.migu.cn 已经变化，请检查本地DNS配置"
        fi

        name3=`dig @$ldns passport-mq.migu.cn +short`
        name4=`dig @$mgdns passport-mq.migu.cn +short`
        echo $name3 $name4 
        if [[ $name3 != $name4 ]]; then
                echo "passport-mq.migu.cn 已经变化，$ldns 获取的值不正确，请进行检查"
                sendsms  "passport-mq.migu.cn 已经变化，$ldns 获取的值不正确，请进行检查"
        fi
done
