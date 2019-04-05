#!/bin/bash

TYPE_DELAY=0.06
EOL_DELAY=1
PROMPT=$

type() {
  args=$1
  local delay=$TYPE_DELAY
  if [ "$2" == "fast" ]
  then
    delay=0.02
  fi

  echo -n $PROMPT" "

  for (( i=0; i<${#args}; i++ ))
  do
    echo -n "${args:$i:1}"
    sleep $delay
  done
  
  sleep $EOL_DELAY
  echo
  
  eval "$1"
  echo
}

show() {
  echo "$1"
  sleep $EOL_DELAY
}

##### SETUP

cd $(dirname $0)/..
rm -rf demo && mkdir demo

cd demo
git init .
git commit --allow-empty -m "Initial commit"


##### DEMO

export GIT_PAGER=cat
export PATH=$PATH:../bin/

clear

#EOL_DELAY=0
#TYPE_DELAY=0

type "git log --oneline --graph --all"
sleep 2

type "git chain branch -c awesome-feature master add-database-table"
show "## ... adding a table ..."
type "echo Some change > whatever.txt" fast
type "git add ." fast
type "git commit -m 'Add table'" fast

type "git chain branch add-model"
show "## ... adding a model ..."
type "echo Another change >> whatever.txt" fast
type "git add ." fast
type "git commit -m 'Add model'" fast

type "git chain branch add-ui"
show "## ... adding a ui ..."
type "echo Another change >> anotherfile.txt" fast
type "git add ." fast
type "git commit -m 'Add ui'" fast
 
show "## We now have a chain"
type "git chain list"

sleep 2

type "git checkout add-database-table"
type "echo More attributes >> whatever.txt" fast
type "git add ." fast
type "git commit -m 'Modified table'" fast

type "git checkout add-model"
type "echo More attributes >> model_only.txt" fast
type "git add ." fast
type "git commit -m 'Modified model'" fast

show "## now let's use git chain 🎉"
type "git chain rebase"

#EOL_DELAY=1

show "## a conflict 🙀 - let's resolve this 😁"
type "echo My changes are better > whatever.txt" fast
type "git add ." fast
type "git commit -m 'Add model (with changes)'"
type "git rebase --continue"
type "git chain rebase"

