#!/bin/sh
SCRIPT=$1
CNT=1
while :
do
    sh $SCRIPT
    echo $CNT
    sleep 1
    CNT=$(( CNT + 1 ))
done