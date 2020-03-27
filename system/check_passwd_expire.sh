#!/bin/bash
# ================================================================
#   Copyright (C) 2018 www.361way.com site All rights reserved.
#   
#   Filename      ：check_passwd_expire.sh
#   Author        ：yangbk <itybku@139.com>
#   Create Time   ：2020-03-27 16:09
#   Description   ：
#   
#   user 用户名  
#   day 密码有效时长（自1970-01-01）
#   mexpiry 最大时长，一般是90天或180天 ，该值为空和99999一样，永不过期 
# ================================================================

cat /etc/shadow|grep -v '!'|grep -v ':99999:'|awk -F: '{print $1,$3,$5}'|while read user day mexpiry
do 
    #echo $mexpiry

    if [[ -n $mexpiry ]]; then
        warnday=$((`date +%s`/86400 - $day - $mexpiry + 1))
        #echo $warnday
          if [[ $warnday -le 10 ]]; then
                #echo $user $day $mexpiry
                echo "`hostname`:$user will be expires in $warnday day"
          fi
    fi
done
