source "$PR_SIZE_LABELER_HOME/src/rocket.sh"

# $1 -> Chat Url
# $2 -> Message
# $3 -> Group hook (opt)
# $4,$5,$6 -> Private message params

msg="$2"
user="$4"
pass="$5"
to="$6"
bot_name=${7:-CI-Bot}

msg=${msg//__/\\n}
msg=${msg//::/\`}

sendPrivateMessage(){
  TO="@$to"
  echo "$msg"
  loginData="{\"user\":\"$user\",\"password\":\"$pass\"}"
  data="{\"channel\":\"${TO}\",\"text\":\"${msg}\",\"username\":\"${BOT_NAME}\",\"avatar\":\"${BOT_AVATAR}\"}"
  login=$(curl -s -H "Content-type:application/json" "$ROCKET_CHAT_URL$URL_LOGIN" -d "$loginData")
  userData=$(echo "$login" | jq '.data')
  userId=$(echo "$userData" | jq -r '.userId')
  token=$(echo "$userData" | jq -r '.authToken')

  response=$(curl -d "$data" -H "Content-type:application/json" -H "X-User-Id: $userId" -H "X-Auth-Token: $token" $ROCKET_CHAT_URL$SEND_MESSAGE_URL)
  echo $response
}


main(){

export ROCKET_CHAT_URL="$1"
export BOT_NAME="$bot_name"
export BOT_AVATAR="$8"

if [[ -n "$5" ]]; then
  sendPrivateMessage
else
  rocket::sendGroupMessage $3 $2
fi
   exit $?
}
