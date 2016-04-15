# run me before docker-compose up -d in order to set your env variable
# for PHP to hook up to local xdebug listeners using remote_host
remotehost="remote_host"
guestip=$(docker-machine ip default)
ip="$(echo "$guestip" | sed 's/\.[0-9]*$/.1/')"

echo "export XDEBUG_CONFIG=\"$remotehost=$ip\""
