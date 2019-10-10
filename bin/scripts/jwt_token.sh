#!/bin/bash

#Usage this_script.sh $JWT

decode_base64_url() {
	local len=$((${#1} % 4))
	local result="$1"

	if [ $len -eq 2 ]; then
		 result="$1"'=='
	elif [ $len -eq 3 ]; then
		result="$1"'='
	fi
	
	echo "$result" | tr '_-' '/+' | openssl enc -d -base64
}

decode_jwt(){
	tmp=$(echo -n "$2" | cut -d "." -f "$1")
   decode_base64_url $tmp | jq .
}

[ -z $1  ] && echo "Missing JWT Header or Payload" && exit 1

printf "\nHeader:\n" && \
decode_jwt "1" "$1" && \
printf "\nPayload:\n" && \
decode_jwt "2" "$1" && \
exit 0

echo "Ran nothing" && exit 1

