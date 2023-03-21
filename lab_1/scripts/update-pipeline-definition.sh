#!/usr/bin/env bash

#check if JQ installed
checkJQ() {
 type jq >/dev/null 2>&1
  exitCode=$?
  if [ "$exitCode" -ne 0 ]; then
    printf "    JQ not found! (json parser)\n"
    printf "    Ubuntu Installation: sudo apt install jq\n"
    printf "    Redhat Installation: sudo yum install jq\n"
    exit 1
  fi
}

checkJQ

json=$1

if [ -z $json ]; then
  echo "need a path to the file"
  exit 1
fi

#flags 
  branch='main'
  pfschanges='false'

  while [[ $# -gt 1 ]]
  do
    case $1 in 
      --owner) ownr="$2"
        shift ;;
      --configuration) conf="$2"
        shift ;;
      --branch) branch="$2"
        shift ;;
      --pol-for-source-changes) pfschanges="$2"
        shift ;;
    esac
    shift
  done

  
  temp="$(dirname "$1")/temp.json"
  UPDATED="$(dirname "$1")/pipeline-`date +"%m-%d-%y"`.json"

  cp $json $UPDATED
# remove metadata
jq "del(.metadata)" $UPDATED > $temp && mv $temp $UPDATED
# increment version
jq ".pipeline.version += 1" $UPDATED > $temp && mv $temp $UPDATED

# in the source  
# update branch
jq --arg b $branch '.pipeline.stages[0].actions[0].configuration.Branch
= $b' $UPDATED > $temp && mv $temp $UPDATED

# update pfschanges
jq --arg pfs  "$pfschanges" '.pipeline.stages[0].actions[0].configuration.PollForSourceChanges = $pfs' $UPDATED > $temp && mv $temp $UPDATED
# update owner
jq --arg o "$ownr" '.pipeline.stages[0].actions[0].configuration.Owner = $o' $UPDATED > $temp && mv $temp $UPDATED


echo "$UPDATED was created"





