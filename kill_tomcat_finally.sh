#!/bin/sh
#. /etc/rc.d/init.d/functions
#@author houqian
#@version v1.1
#@createtime:2015年9月12日23:03:38
#@updatetime:2016年06月12日15:01:04
#@description:kill tomcat

CURRENT_TOMCAT_DIR=`pwd | rev | awk -F \/ '{print $2}' | rev`
TOMCAT_PID=`ps -ef | grep java | grep $CURRENT_TOMCAT_DIR|awk '{print $2}'`  
CUR_DIR=$(pwd)
check() {
	if test ["$TOMCAT_PID" = ""];then 
		echo 'tomcat is not running'
	exit 0
	fi		
}
stopProcess() {
	for id in $TOMCAT_PID
	do
        	kill $id
	done
	echo 'tomcat $CURRENT_TOMCAT_DIR is killed..'
	echo ':-D'
}
checkRunning() {
	if test ["$TOMCAT_PID" = ""];then
		echo "$CURRENT_TOMCAT_DIR is running"
	else
		echo "$CURRENT_TOMCAT_DIR is not running"
	fi

}
stop() {
	sh $CUR_DIR/shutdown.sh > /dev/null 2>&1                                                                                                     
        echo ''                                                                                                                                      
        check                                                                                                                                        
        stopProcess                                                                                                                                  
        checkRunning 
}
status() {
        ps -ef | grep $CURRENT_TOMCAT_DIR                                                                                                            
}
tail() {
	tail -f ../logs/catalina.out
}
start() {
	echo 'start normally...'
	sh $CUR_DIR/startup_noAgent.sh 
}
debug() {
	echo 'start using jpda mode..' 
	sh $CUR_DIR/catalina.sh jpda start		
}
restart() {
	stop
	start
}

case "$1" in 
	stop)
		stop
	;;
	status)
		status
	;;
	tail)
		tail
	;;
	start)
		start
	;;
	debug)
		debug
	;;
	restart)
		restart
	;;
	*)
		echo "[stop|status|tail|start|debug]"
		echo "please run shutdown.sh first."
		echo "you will never have to exec 'ps -ef |grep java, kill xxxx',enjoy it."
		echo "this shell will kill all of the current directory for Tomcat processes and it was a universal shell if you drop it in TOMCAT_HOME/bin "
esac
exit 1

