#!/bin/bash
#同步数据库
#当前脚本路径
debug="false"
macos="false"
script_dir=$(dirname $0)

#用户登陆名称
src_user='wnlbs'
src_pwd='wnlbs'
dest_user='wnlbs'
dest_pwd='wnlbs'

#源数据库名称
src_db_name='unpn'
src_host='120.194.14.6'
#目的数据库名称
dest_db_name='unpn'
dest_host='localhost'
#源DNS
src_base_dns="h=${src_host},D=${src_db_name},u=${src_user},p=${src_pwd},A=utf8"
#目的DNS
dest_base_dns="h=${dest_host},D=${dest_db_name},u=${dest_user},p=${dest_pwd},A=utf8"

syn_tables=(ep epstat alm gps)

#共有10台设备
#1433602372 |
#1366440277 |
#1433198107 |
#1433151821 |
#1433150714 |
#1430788718 |
#1433133676 |
#883846810  |
#1433069428 |
#1433062061 |
where="epid in ('1433602372','1433062061','1433198107','','','','','','','','')"

for t in ${syn_tables[@]}
do
    tbl=",t=${t}"
    src=$src_base_dns$tbl
    dest=$dest_base_dns$tbl
    #同步基础数据
    echo "同步表${t}"
    if [ $debug = "true" ]
    then
        $script_dir/percona-toolkit-2.1.4/bin/pt-table-sync --print --where "${where}"  $src $dest
    else
        $script_dir/percona-toolkit-2.1.4/bin/pt-table-sync --print  --where "${where}" --execute $src $dest
    fi
done
echo "-----------------------------------------------运行结束-----------------------------------------------"
