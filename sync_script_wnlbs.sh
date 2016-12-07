#!/bin/bash
#同步数据库
#当前脚本路径
debug="false"
macos="false"
script_dir=$(dirname $0)

#用户登陆名称
src_user='root'
src_pwd='123456'
dest_user='root'
dest_pwd='123456'

#源数据库名称
src_db_name='unpn'
src_host='10.42.240.35'
#目的数据库名称
dest_db_name='antongdb'
dest_host='localhost'
#源DNS
src_base_dns="h=${src_host},D=${src_db_name},u=${src_user},p=${src_pwd},A=utf8"
#目的DNS
dest_base_dns="h=${dest_host},D=${dest_db_name},u=${dest_user},p=${dest_pwd},A=utf8"

syn_tables=(ep epstat alm gps)

for t in ${syn_tables[@]}
do
    src_tbl=",t=${t}"
    desc_tbl=",t=gis_${t}"
    src=$src_base_dns$src_tbl
    dest=$dest_base_dns$dest_tbl
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
