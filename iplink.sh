#!/bin/bash

# create a bridge (switch) internal to the container
/usr/sbin/ip link add brfw type bridge

# following allows use of iptables with the new bridge
/usr/sbin/ip link set dev brfw type bridge nf_call_iptables 1

# disable the interface so changes can be made
/usr/sbin/ip link set brfw down 
/usr/sbin/ip link set eth0 down
/usr/sbin/ip link set eth1 down

# Following will generate two errors that complain about brfw being "garbage".
# Those messages are safe to ignore.  Adding "2> /dev/null" suppresses the messages.

# Attach the external interfaces with the internal switch
/usr/sbin/ip link set eth0 brfw 2> /dev/null
/usr/sbin/ip link set eth1 brfw 2> /dev/null

# return the interfaces to operation
/usr/sbin/ip link set brfw up 
/usr/sbin/ip link set eth0 up 
/usr/sbin/ip link set eth1 up 

