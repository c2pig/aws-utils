#!/bin/sh
cord_server_ip=$1

[ $# -ne 1 ] && {
  echo "Usage: $0 <cordinator server public ip>"
  exit 1;
}
jmeter -p master.properties -Djava.rmi.server.hostname=$cord_server_ip $*
