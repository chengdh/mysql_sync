#!/bin/bash
#同步数据库中的rule和notice
#当前脚本路径
debug="false"
script_dir=$(dirname $0)

#用户登陆名称
src_user='root'
src_pwd='root'
dest_user='root'
dest_pwd='root'

#源数据库名称
src_db_name='yanzhao-mis_production'
src_host='localhost'
#目的数据库名称
dest_db_name='il_yanzhao_production'
dest_host='localhost'
#源DNS
src_base_dns="h=${src_host},P=13306,D=${src_db_name},u=${src_user},p=${src_pwd},A=utf8,t=base_public_messages"
#目的DNS
dest_base_dns="h=${dest_host},P=13306,D=${dest_db_name},u=${dest_user},p=${dest_pwd},A=utf8,t=messages"

#同步基础数据
echo "同步base_public_messages"
if [ $debug = "true" ]
then
  $script_dir/percona-toolkit-2.1.4/bin/pt-table-sync --print  $src_base_dns $dest_base_dns
else
  $script_dir/percona-toolkit-2.1.4/bin/pt-table-sync --print --execute $src_base_dns $dest_base_dns
fi
echo "-----------------------------------------------运行结束-----------------------------------------------"
