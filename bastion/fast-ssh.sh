#!/bin/bash
configFile="server.conf"

add() {
  echo -e "\033[32mPlease input your login method,ssh or sftp:\033[0m"
  read -r method
  method=$(echo "$method" | tr 'a-z' 'A-Z')
  if [ "$method" != "SSH" ] && [ "$method" != "SFTP" ]; then
    echo -e "\033[31minvalid method!\033[0m"
    exit 1
  fi
  echo -e "\033[32mPlease input your server name:\033[0m"
  read -r name
  echo -e "\033[32mPlease input your server ip:\033[0m"
  read -r ip
  echo -e "\033[32mPlease input your server port:\033[0m"
  read -r port
  echo -e "\033[32mPlease input your server username:\033[0m"
  read -r username
  echo -e "\033[32mPlease input your server password, if you login with public key,you need to press enter:\033[0m"
  read -r password
  secCount=$(Count "$method""-")
  newNum=$(($secCount + 1))
  sectionN="$method""-""$newNum"
  source ./file.sh -w "$sectionN" passwd "$password" $configFile
  source ./file.sh -w "$sectionN" user "$username" $configFile
  source ./file.sh -w "$sectionN" port "$port" $configFile
  source ./file.sh -w "$sectionN" ip "$ip" $configFile
  source ./file.sh -w "$sectionN" alias "$name" $configFile
  exit 0
}

function Delete() {
  echo 1
}

function Choose() {
  echo -e "\033[32mPlease input your selection number:\033[0m"
  read -r -n 1 choice
  echo -e "\n\033[32myour choice is: \033[0m""\033[36m$choice\033[0m"
}

function Count() {
  which=$1
  count=$(awk "/""$which""/" "$configFile" | wc -l)
  echo "$count"
}

function ReadConfFile() {
  key=$1
  section=$2
  configFile=$3
  ReadINI=$(awk -F '=' '/\['"$section"'\]/{a=1}a==1&&$1~/'"$key"'/{print $2;exit}' "$configFile")
  echo "$ReadINI" | sed 's/^[ ]*//g'
}

function Read() {
  which=$1
  count=$(Count "$which")
  for ((i = 1; i <= "$count"; i++)); do
    num=$((num + 1))
    section="$which""$i"
    map["$num"]="$section"
    alias=$(ReadConfFile "alias" "$section" "$configFile")
    head="\033[36m"
    tail="\033[0m"
    formatNum=$head$num\)$tail
    formatName=$head$alias$tail
    echo -e "$formatNum    $formatName"
  done
}

function EchoFormatServer() {
  echo -e "\033[32mNum  ServerName\n\033[0m"
}

help() {
  cat <<-EOF
  Usage: ./fash-ssh.sh [options]
  Options：
   -h, --help     print command line options

   -v, --version  print fast-ssh's version

   -a, --add      add host

   -d, --delete   delete host
EOF
  exit 0
}

version_info() {
  cat <<-EOF
   fast-ssh.sh v1.0.0
EOF
  exit 0
}

echo
while [ -n "$1" ]; do #这里通过判断$1是否存在
  case $1 in
  -h | --help) help ;;
  -v | --version) version_info ;;
  -a | --add) add ;;
  --)
    shift
    break
    ;;
  -*)
    echo "error: no such option $1."
    exit 1
    ;;
  *) break ;;
  esac
done

num=0
declare map=()

echo -e "\033[34m===================SSH========================\033[0m"
EchoFormatServer
Read "SSH-"
echo -e "\033[34m===================SFTP========================\033[0m"
EchoFormatServer
Read "SFTP-"

Choose

if [ "$choice" -gt "$num" ]; then
  echo -e "\033[31minvalid select number!\033[0m"
  exit 1
fi

section=${map["$choice"]}
ip=$(ReadConfFile "ip" "$section" "$configFile")
port=$(ReadConfFile "port" "$section" "$configFile")
user=$(ReadConfFile "user" "$section" "$configFile")
passwd=$(ReadConfFile "passwd" "$section" "$configFile")
method=${section%-*}
host="$user""@""$ip"

exec ./login.exp "$method" "$host" "$port" "$passwd"
