#!/usr/bin/env bash
cd $(dirname $0)
nohup bin/jmeter-server -Djava.rmi.server.hostname=$(ip route get 8.8.8.8 | head -1 | cut -d' ' -f7) > jmeter-server.log 2> jmeter-server.err &
