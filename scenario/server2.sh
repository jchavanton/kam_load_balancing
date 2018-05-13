ulimit -c unlimited
COREDIR=/tmp
[ -d $COREDIR ] || mkdir $COREDIR
chmod 777 $COREDIR
echo "$COREDIR/core.%e.sig%s.%p" > /proc/sys/kernel/core_pattern
echo "1" > /proc/sys/kernel/core_uses_pid
killall kamailio && kamailio -f /etc/kamailio.cfg -M 32 -m 512 -A WITH_CC
# sleep 6
kamcmd dispatcher.list
tail -f /var/log/syslog | cut -c 100-
