#!/bin/bash

committer_email=$(git log -1 --pretty=%ae)
slack_user_list=$(curl -H "application/x-www-form-urlencoded" "https://slack.com/api/users.list?token=$KHALEESI_SLACK_TOKEN&pretty=1")
members=()

if [[ $committer_email == "ronkeizer@gmail.com" ]]; then
  committer_email="ron@insight-rx.com"
fi

echo $committer_email

members+=($(echo "$slack_user_list" | jq -r ".members[$a].id"))

for (( a=0; a<${#members[@]}; a++ ))
do
  slack_email=$(echo "$slack_user_list" | jq -r ".members[$a].profile.email")
  if [[ $committer_email == $slack_email ]]; then
    slack_id=$(echo "$slack_user_list" | jq -r ".members[$a].id")
    break
  fi
done

echo "Committer email $committer_email has slack id $slack_id"
echo "======================================================="

# Publish sns topic with json of relevant build info
printf "{\"committer\":\""$slack_id"\", \"job\":\""$JOB_NAME"\", \"branch\":\""$GIT_BRANCH"\", \"build_number\":\""$BUILD_NUMBER"\", \"build_url\":\""$BUILD_URL"\", \"build_status\":\""$STATUS"\"}" >> ~/workspace/slack_notification.json

aws sns publish --topic-arn $JENKINS_SLACKBOT --message file://~/workspace/slack_notification.json --region us-west-1
