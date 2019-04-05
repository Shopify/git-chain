#!/bin/bash

TYPE_DELAY=0.06
EOL_DELAY=1
PROMPT=$

type() {
  args=$1
  echo -n $PROMPT" "

  for (( i=0; i<${#args}; i++ ))
  do
    echo -n "${args:$i:1}"
    sleep $TYPE_DELAY
  done
  
  sleep $EOL_DELAY
  echo
  
  eval "$1"
  echo
}


##### SETUP

cd $(dirname $0)/..
rm -rf demo && mkdir demo

cd demo
../fixtures/a-b-conflicts.sh


##### DEMO

export GIT_PAGER=cat
export PATH=$PATH:../bin/

clear

type "git log --oneline --graph --all"
sleep 2

type "git checkout a"
type "git chain rebase"

type "echo I want the changes from b > b.txt"
type "git add ."
type "git commit -m 'Resolved conflict'"
type "git rebase --continue"
type "git chain rebase"

type "git log --oneline --graph --all"
sleep 2

