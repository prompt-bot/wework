#!/bin/bash

# shell调用企业微信发送消息命令
# ./weowrk.sh ${人员} "消息"
# 例：
# ./wework.sh @all "hello!"
# ./wework.sh maYun "hello!"
# 注：
# 消息中可以使用"\n"表示换行；
# 消息中不可以使用空格；

# 微信接口参数
# 根据自己申请的企业微信上接口参数调整；
corpid=$WEWORK_CORPID
corpid=${corpid:-${INPUT_WEWORK_CORPID}}
appsecret=$WEWORK_APPSECRET
appsecret=-${appsecret:-${INPUT_WEWORK_APPSECRET}}
agentid=$WEWORK_AGENTID
agentid=${agentid:-${INPUT_WEWORK_AGENTID}}

# 用户列表
# 格式： [{"name":"testuser1","userid":"31ee8a9e9d1d67d2b15c87f7cba7ea0a"}]
userList=$WEWORK_USERLIST
userList=${userList:-${INPUT_WEWORK_USERLIST}}
userList=${userList:-'[]'}

#部门列表
# 格式： [{"name":"department1","partyid":"c2ee8a1e9d9d6bc2b15c8cf2cba7ea00"}]
partyList=$WEWORK_PARTYLIST
partyList=${partyList:-${INPUT_WEWORK_PARTYLIST}}
partyList=${partyList:-'[]'}

# 消息接收用户，使用|分割的用户id列表
touser=${WEWORK_TOUSER}
touser=-${touser:-${INPUT_WEWORK_TOUSER}}

# 消息接收部门，使用|分割的部分id列表
toparty=${WEWORK_toparty}
toparty=-${toparty:-${INPUT_WEWORK_toparty}}


# 消息内容
content=${WEWORK_CONTENT}
content=${content:-${INPUT_WEWORK_CONTENT}}

msgtype=${WEWORK_MSGTYPE:-'markdown'}

if [ -z "$corpid" -o -z "$appsecret" -o -z "$agentid" ]; then
    echo "未设置企业微信应用相关消息"
    echo "env[ WEWORK_CORPID， WEWORK_APPSECRET， WEWORK_AGENTID ]不能为空"
    exit 1;
fi

if [ -z "$touser" -a -z "$toparty" ];then
    echo "未设置消息接受者相关消息"
    echo "env[ WEWORK_TOUSER，  WEWORK_TOPARTY ]不能为空"
    exit 1;
fi

if [ -z "$content" ];then
    echo "未设置发送消息体"
    echo "env[ WEWORK_CONTENT ]不能为空"
    exit 1;
fi

if [ "$userList" != '[]' ];then
    OLD_IFS="$IFS"
    IFS="|"
    echo $touser
    templist=($touser)
    IFS="$OLD_IFS"
    touser=
    for u in ${templist[@]}
    do
        userid=$(echo $userList | jq 'map(select(.name == "'$u'"))'| jq -r .[].userid);
        if [ ! -z "$touser" ];then
            touser=$touser"|$userid";
        else
            touser=$userid;
        fi
    done
fi


if [ "$partyList" != '[]' ];then
    OLD_IFS="$IFS"
    IFS="|"
    templist=($toparty)
    IFS="$OLD_IFS"
    toparty=
    for u in ${templist[@]}
    do
        partyid=$(echo $userList | jq 'map(select(.name == "'$u'"))'| jq -r .[].partyid);
        if [ ! -z "$toparty" ];then
            toparty=$toparty"|$partyid";
        else
            toparty=$partyid;
        fi
    done
fi

if [ -z "$touser" -a -z "$toparty" ];then
    echo "未设置消息接受者相关消息"
    echo "请检查发送参数env[WEWORK_USERLIST, WEWORK_TOPARTY, WEWORK_TOUSER, WEWORK_PARTYLIST]"
    exit 1;
fi

#获取accesstoken
accesstoken=$(/usr/bin/curl -sSl https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=${corpid}\&corpsecret=${appsecret}| jq -r '.access_token')
#发送消息
# echo $accesstoken
msgsend_url="https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=${accesstoken}"
json_params="{\"touser\":\"${touser}\",\"toparty\":\"${toparty}\",\"msgtype\":\"${msgtype}\",\"agentid\":\"${agentid}\",\"${msgtype}\":{\"content\":\"${content}\"},\"safe\":\"0\"}"
echo $json_params
curl -sSl -XPOST -d "${json_params}" "${msgsend_url}"
