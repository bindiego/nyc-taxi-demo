#!/bin/bash

# Author: Bin Wu <bin.wu@elastic.co>

PWD=`pwd`
JAVA=$PWD/deploy/jre/jre8/bin/java
JAVAH=$PWD/deploy/jre/jre8
VER=$(<ver)
IPADDR=$(hostname -I | cut -d ' ' -f 1)

__usage() {
    echo "Usage: ls.sh {deploy|import}"
}

__get_jre() {
	[ -d $PWD/deploy/jre ] || mkdir -p $PWD/deploy/jre
    [ -f $PWD/deploy/jre/jre8.tar.gz ] || \
        curl \
        -v -j -k -L -H "Cookie: oraclelicense=accept-securebackup-cookie" \
        https://download.oracle.com/otn-pub/java/jdk/8u202-b08/1961070e4c9b4e26a04e7f5a083f551e/jre-8u202-linux-x64.tar.gz \
        --output $PWD/deploy/jre/jre8.tar.gz
    tar xzf $PWD/deploy/jre/jre8.tar.gz -C $PWD/deploy/jre && \
        ln -s $PWD/deploy/jre/jre1.8.0_202 $PWD/deploy/jre/jre8
}

__deploy() {
    # setup directories
	[ -d $PWD/deploy ] || mkdir -p $PWD/deploy
	[ -d $PWD/data ] || mkdir -p $PWD/data
	[ -d $PWD/data/ls/logs ] || mkdir -p $PWD/data/ls/logs
	[ -d $PWD/data/ls/queue] || mkdir -p $PWD/data/ls/queue
    [ -f taxi.conf ] || cp taxi.conf.template taxi.conf

    __get_jre

    # download the package
	[ -f $PWD/deploy/logstash.tar.gz ] || \
		curl \
        https://artifacts.elastic.co/downloads/logstash/logstash-$VER.tar.gz \
		--output $PWD/deploy/logstash.tar.gz
    tar xzf $PWD/deploy/logstash.tar.gz -C $PWD/deploy && \
        ln -s $PWD/deploy/logstash-$VER $PWD/deploy/logstash

    echo "Pleasd update Elasticsearch username and password in taxi.conf before importing data"
}

__import() {
    echo -n "Importing NYC taxi data to targeted Elasticsearch ... "

    for csv_data in $PWD/data/*.csv
    do
        tail -n +2 $csv_data | JAVA_HOME=$JAVAH JAVACMD=$JAVA $PWD/deploy/logstash/bin/logstash \
            --node.name bindiego \
            -f $PWD/taxi.conf

        if [ $? -eq 0 ]
        then
            PID=`ps -elf | egrep "logstash" | egrep -v "ls.sh|grep" | awk '{print $4}'`
            echo "succeed."
        else
            echo "failed."
        fi
    done

    echo "Go to Kibana, create index patter called 'nyc-taxi-*'"
}

__main() {
    if [ $# -eq 0 ]
    then
        __usage
    else
        case $1 in
            deploy)
                __deploy
                ;;
            import)
                __import
                ;;
            *)
                __usage
                ;;
        esac
    fi
}

__main $@

exit 0
