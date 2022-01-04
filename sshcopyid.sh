#!/bin/bash

# define output color
# set echo
echo=echo
for cmd in echo /bin/echo; do
  $cmd >/dev/null 2>&1 || continue
  if ! $cmd -e "" | grep -qE '^-e'; then
    echo=$cmd
    break
  fi
done
# set color
CSI=$($echo -e "\033[")
CEND="${CSI}0m"
CDGREEN="${CSI}32m"
CRED="${CSI}1;31m"
CGREEN="${CSI}1;32m"
CYELLOW="${CSI}1;33m"
CBLUE="${CSI}1;34m"
CMAGENTA="${CSI}1;35m"
CCYAN="${CSI}1;36m"
CSUCCESS="$CDGREEN"
CFAILURE="$CRED"
CQUESTION="$CMAGENTA"
CWARNING="$CYELLOW"
CMSG="$CCYAN"


ERROR_FILE="/tmp/ssh-copy_error.txt"

if ! command -v sshpass >/dev/null;then 
    echo "${CFAILURE}cannot find sshpass command. exit.${CEND}"
    exit 1
fi

function auto_ssh_copy_id() {
    sshpass -p $2 ssh-copy-id -p $3 -o "StrictHostKeyChecking no" $4@$1 2>$ERROR_FILE
    RESULT=$?
    if [ $RESULT -eq 0 ]; then
        echo ""
        echo "${CSUCCESS}Public key successfully copied to $1, ssh_user: $4, ssh_port: $3${CEND}"
        echo ""
    else
        echo ""
        echo "${CFAILURE}Public key copied to $1 ERROR, ssh_user: $4, ssh_port: $3. ERROR message:${CEND}"
        echo "$( cat  $ERROR_FILE )"
        echo ""
    fi
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
}

function usage() {
    printf \
"automate copy ssh public key to multiple remote servers

Usage: ./sshcopyid.sh [OPTIONS]

Options:
  -f, --host-file       host file txt. default: host.txt
  -i, --host-ip         host ip
  -u, --ssh-user        ssh user
  -p, --ssh-port        ssh port
  -P, --ssh-password    ssh password
  -h, --help            display this help and exit
"
}

HOST_FILE=host.txt
HOST_IP=''
SSH_USER=root
SSH_PORT=22
SSH_PASSWORD=''

# 获取命令行参数
ARGS=`getopt -a -o f:i:u:p:P:h -l host-file:,host-ip:,ssh-user:,ssh-port:,ssh-password:,help -n "sshcopyid.sh" -- "$@"`
[ $? -ne 0 ] && usage
eval set -- "${ARGS}"
while true; do
    case "$1" in
        -f|--host-file) HOST_FILE="$2"; shift ;;
        -i|--host-ip) HOST_IP="$2"; shift ;;
        -u|--ssh-user) SSH_USER="$2"; shift ;;
        -p|--ssh-port) SSH_PORT="$2"; shift ;;
        -P|--ssh-password) SSH_PASSWORD="$2"; shift ;;
        -h|--help) usage; exit 0 ;;
        --) shift; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
    shift
done

if [[ X$HOST_IP != X ]];then
    if [[ X$SSH_PASSWORD == X ]];then
        echo "${CFAILURE}SSH_PASSWORD is empty.${CEND}"
        exit 1
    fi

    auto_ssh_copy_id $HOST_IP $SSH_PASSWORD $SSH_PORT $SSH_USER
else
    host_file=$HOST_FILE

    if [[ ! -f $host_file ]];then
        echo "${CFAILURE}file $host_file not exist.${CEND}"
        exit 1
    fi

    while read -u 9 ssh_ip ssh_pwd ssh_port ssh_user || [[ -n $ssh_ip ]];do
        echo $ssh_ip | grep \# && continue

        if [[ X$ssh_port == X ]];then ssh_port=22;fi
        if [[ X$ssh_user == X ]];then ssh_user=root;fi

        auto_ssh_copy_id $ssh_ip $ssh_pwd $ssh_port $ssh_user
    done 9<${host_file}
fi

rm $ERROR_FILE -f