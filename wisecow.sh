#!/usr/bin/env bash

SRVPORT=4499
RSPFILE=response

rm -f $RSPFILE
mkfifo $RSPFILE

get_api() {
    read line
    echo $line
}

handleRequest() {
    get_api
    mod=$(/usr/games/fortune)

cat <<EOF > $RSPFILE
HTTP/1.1 200
<pre>$('/usr/games/cowsay' "$mod")</pre>
EOF
}

main() {
    echo "Wisdom served on port=$SRVPORT..."

    while [ 1 ]; do
        cat $RSPFILE | nc -lN $SRVPORT | handleRequest
        sleep 0.01
    done
}

main
