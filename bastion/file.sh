#!/bin/bash
section=$2
option=$3
value=$4
confFile=$5

function checkFile() {
  if [ "${confFile}" = "" ] || [ ! -f ${confFile} ]; then
    echo "[error]:file --${confFile}-- not exist!"
  fi
}

function writeFile() {
  #检查文件
  checkFile
  allSections=$(awk -F '[][]' '/\[.*]/{print $2}' "${confFile}")
  result=$(echo "$allSections" | grep "${section}")

  if [[ "$result" != "" ]]; then
    sectionFlag="1"
  else
    sectionFlag="0"
  fi

  if [ "$sectionFlag" = "0" ]; then
    echo "[${section}]" >>"${confFile}"
  fi

  #加入或更新value
  awk "/\[${section}\]/{a=1}a==1" "${confFile}" | sed -e '1d' -e '/^$/d' -e 's/[ \t]*$//g' -e 's/^[ \t]*//g' -e '/\[/,$d' | grep "${option}.\?=" >/dev/null
  if [ "$?" = "0" ]; then
    #更新
    #找到制定section行号码
    sectionNum=$(sed -n -e "/\[${section}\]/=" "${confFile}")
    sed -i '' "${sectionNum},/^\[.*\]/s/\(${option}.\?=\).*/\1 ${value}/g" "${confFile}"
    echo "[success] update [confFile][$section][$option][$value]"
  else
    #新增
    sed -i '' "/^\[${section}\]/a\\
    ${option} = ${value}
    " "${confFile}"
    echo "[success] add [$confFile][$section][$option][$value]"
  fi
}

if [ "$1" == "-w" ]; then
  writeFile
fi
