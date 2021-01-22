#!/bin/bash
# author:admin@yangsifa.com
# 开启群晖隐藏的PHP扩展【redis】【memcached】
# 执行命令：wget -O php_extend.sh https://api.mvgao.com:999/bash/php_extend.sh && sudo bash php_extend.sh

# 文件后部分路径
file="/misc/extension_list.json"

# 检查扩展是存在
function ifextend(){
    text=$(cat ${1} | jq .${2}.enable_default)
    if  [ "${text}" = "null" ];then
        return=false
    else
        return=true
    fi
}

# 执行文件编写
function edit(){
	ifextend ${1} "redis"
	if [ ${return} = false ];then
		sed -i "1a \    \"redis\": {" ${1}
		sed -i "2a \        \"enable_default\": true," ${1}
		sed -i "3a \        \"desc\": \"Key value database based on memory persistence.\"" ${1}
		sed -i "4a \    }," ${1}
		echo ${1} redis：编辑了
	else
		echo ${1} redis：无需修改
	fi

	ifextend ${1} "memcached"
	if [ ${return} = false ];then
		sed -i "1a \    \"memcached\": {" ${1}
		sed -i "2a \        \"enable_default\": true," ${1}
		sed -i "3a \        \"desc\": \"More advanced functions than Memcache.\"" ${1}
		sed -i "4a \    }," ${1}
		echo ${1} memcached：编辑了
	else
		echo ${1} memcached：无需修改
	fi
}

# 查找所有volume目录下的php版本
for path in /volume*/@appstore/*
do
    if test -d $path
    then
		if  [ -f $path$file ];then
		  edit $path$file
		fi
    fi
done
