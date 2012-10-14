#!/bin/bash
#同步数据库
#当前脚本路径
debug="false"
macos="false"
script_dir=$(dirname $0)

#用户登陆名称
src_user='root'
src_pwd='root'
dest_user='root'
dest_pwd='root'

#源数据库名称
src_db_name='il_yanzhao_production'
src_host='localhost'
#目的数据库名称
dest_db_name='il_yanzhao_cx_production'
dest_host='localhost'
#源DNS
src_base_dns="h=${src_host},D=${src_db_name},u=${src_user},p=${src_pwd},A=utf8"
#目的DNS
dest_base_dns="h=${dest_host},D=${dest_db_name},u=${dest_user},p=${dest_pwd},A=utf8"

syn_tables=(orgs system_function_groups system_functions system_function_operates roles role_system_functions role_system_function_operates banks il_configs areas users user_orgs user_roles customers)

for t in ${syn_tables[@]}
do
    tbl=",t=${t}"
    src=$src_base_dns$tbl
    dest=$dest_base_dns$tbl
    #同步基础数据
    echo "同步基础数据${t}"
    if [ $debug = "true" ]
    then
        $script_dir/percona-toolkit-2.1.4/bin/pt-table-sync --print  $src $dest
    else
        $script_dir/percona-toolkit-2.1.4/bin/pt-table-sync --print --execute $src $dest
    fi
done
#取得昨天时间
if [ $macos = "true" ]
then
    yesterday=$(date -v-1d +%Y-%m-%d)
else
    yesterday=$(date -d"yesterday" +%Y-%m-%d)
fi
#业务数据
src_bill_dns="${src_base_dns},t=carrying_bills"
dest_bill_dns="${dest_base_dns},t=carrying_bills"
#28为磁县id
to_org_id=28
where="bill_date='${yesterday}' and to_org_id=${to_org_id}"
#同步运单数据
echo "-----------------------------------------------同步运单数据-----------------------------------------"
if [ $debug = "true" ]
then
    $script_dir/percona-toolkit-2.1.4/bin/pt-table-sync --print  --where "${where}" $src_bill_dns $dest_bill_dns
else
    $script_dir/percona-toolkit-2.1.4/bin/pt-table-sync --print --execute --where "${where}" $src_bill_dns $dest_bill_dns
fi
echo "-----------------------------------------同步运单数据结束---------------------------------------------"
if [ $debug != "true" ]
then
    #更新目的库的运单状态为已开票状态
    update_carrying_bill_sql="UPDATE carrying_bills SET state='billed' WHERE bill_date='${yesterday}'"
    echo $update_carrying_bill_sql>$script_dir/update_carrying_bill.sql
    mysql_connect_str="-h${dest_host}  -u${dest_user} -p${dest_pwd}  ${dest_db_name}"
    echo "-----------------------------------------------更新运单状态-----------------------------------------"
    mysql $mysql_connect_str < $script_dir/update_carrying_bill.sql
    rm $script_dir/update_carrying_bill.sql
fi
echo "-----------------------------------------------运行结束-----------------------------------------------"
