#!/bin/bash

SSH_PRIVATE_KEY=$1
DOKKU_USER=$2
DOKKU_HOST=$3
DOKKU_IP_ADDRESS=$4
DOKKU_APP_NAME=$5
DOKKU_REMOTE_BRANCH=$6
GIT_PUSH_FLAGS=$7
GIT_SUBTREE_PREFIX=$8
FORCE_PUSH_SUBTREE=$9

# Setup the SSH environment
mkdir -p ~/.ssh
eval `ssh-agent -s`
ssh-add - <<< "$SSH_PRIVATE_KEY"
ssh-keyscan $DOKKU_HOST >> ~/.ssh/known_hosts

host=""
if [ $DOKKU_IP_ADDRESS ]
then
    host=$DOKKU_IP_ADDRESS
else
    host=$DOKKU_HOST
fi

# Setup the git environment
git_repo="$DOKKU_USER@$host:$DOKKU_APP_NAME"
echo "git_repo=$git_repo"

cd "$GITHUB_WORKSPACE"
git remote add dokku $git_repo

# Check that the remote has been correctly added
git remote -v

# Prepare to push to Dokku git repository
GIT_COMMAND=""
if [ $FORCE_PUSH_SUBTREE ]
then
    GIT_COMMAND="git push dokku `git subtree split --prefix $GIT_SUBTREE_PREFIX master`:$DOKKU_REMOTE_BRANCH --force"
else
    GIT_COMMAND="git subtree push --prefix ${GIT_SUBTREE_PREFIX} dokku $DOKKU_REMOTE_BRANCH"
fi
echo "GIT_COMMAND=$GIT_COMMAND"

# Push to Dokku git repository
GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no" $GIT_COMMAND
