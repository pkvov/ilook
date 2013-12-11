#!/bin/sh

if [ -z "$1" ]; then
    echo "start server development"
    #start goagent proxy
    nohup python ~/software/goagent-2.1.5/local/proxy.py > /dev/null 2>&1&

    #start redis-server
    nohup redis-server  > /dev/null 2>&1&

    #start sidekiq
    nohup bundle exec sidekiq &

    #start clockwork
    nohup clockwork workers/refresh_quote.rb > /dev/null 2>&1&

    #start server
    padrino start -h="0.0.0.0" -d

else
    echo "stop server"

    ps aux | grep clockwork | awk '{print $2}' | xargs kill -9

    ps aux | grep sidekiq | awk '{print $2}' | xargs kill -9

    ps aux | grep redis-server | awk '{print $2}' | xargs kill -9

    ps aux | grep goagent | awk '{print $2}' | xargs kill -9

    padrino stop

    #clear all logs
    rm -rf ./log/*
    rm -rf ./nohup.out
fi


