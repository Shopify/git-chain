#!/bin/bash

TYPE_DELAY=0.06
EOL_DELAY=1
PROMPT="\x1B[0;35m\$\x1B[0m"

type() {
  args=$1
  local delay=$TYPE_DELAY
  local eol_delay=$EOL_DELAY
  if [[ "$2" == "fast" ]]
  then
    delay=0.02
    eol_delay=0.5
  fi

  echo -en "${PROMPT} "

  for (( i=0; i<${#args}; i++ ))
  do
    echo -n "${args:$i:1}"
    sleep $delay
  done

  sleep $eol_delay
  echo

  eval "$1"
  echo
}

comment() {
  echo -e "–-– \x1B[0;36m$1\x1B[0m –––"
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

#type "git log --oneline --graph --all"
#sleep 2

comment "Starting a chain for our \x1B[0;33mAwesome Feature\x1B[0;36m"
type "git chain branch -c awesome-feature master add-database-table"

comment "Adding a table"
type "echo Some change > whatever.txt" fast
type "git add ." fast
type "git commit -m 'Add table'" fast

comment "Add a \x1B[0;33msecond\x1B[0;36m branch to the chain"
type "git chain branch add-model"
type "echo Another change >> whatever.txt" fast
type "git commit -a -m 'Add model'" fast

comment "Add a \x1B[0;33mthird\x1B[0;36m branch to the chain"
type "git chain branch add-ui"
type "echo Another change >> anotherfile.txt" fast
type "git add ." fast
type "git commit -m 'Add ui'" fast

comment "Our chain now has \x1B[0;33m3\x1B[0;36m branches"
type "git chain list"

sleep 2

comment "Let's go back and add a commit to our \x1B[0;33mfirst\x1B[0;36m branch."
type "git checkout add-database-table"
type "echo More attributes >> whatever.txt" fast
type "git commit -a -m 'Modified table'" fast

comment "And add a commit to our \x1B[0;33msecond\x1B[0;36m branch for good measure."
type "git checkout add-model"
type "echo More attributes >> model_only.txt" fast
type "git add ." fast
type "git commit -m 'Modified model'" fast

comment "Now let's use \x1B[0;33mgit chain\x1B[0;36m and realign all of our branches."
type "git chain rebase"

#EOL_DELAY=1

comment "A conflict 🙀 - let's resolve this 😁"
type "echo My changes are better > whatever.txt" fast
type "git commit -a -m 'Add model (with changes)'"
type "git rebase --continue"

comment "Now that the conflict is resolved, \x1B[0;33mgit chain\x1B[0;36m succeeds 🎉"
type "git chain rebase"

