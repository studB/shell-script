#!/bin/bash

while getopts 'd' OPTIONS; do
    case "$OPTIONS" in
        d)
            DESMODE=1 ;;
    esac
done

title() {
    echo 
    echo "====== $1"
    echo 
}

#############################
## Description 
#############################

descript() {
    echo
    echo "   ###############"
    echo "       Sample "
    echo "   ###############"
    title "CPU INFO"
    echo "  CPUS : 12"
    echo "  CORES/CPU : 6"
    echo "  MODEL : Intel(R) Core(TM) i7-9750H CPU @ 2.60GHz"
    title "MEMORY INFO"
    echo "  MEM : 16.0 GB"
    echo "  USE : 51 %"
    title "DISK INFO"
    echo "  Filesystem            Size  Used Avail Use% Mounted on"
    echo "  C:/Program Files/Git  477G  210G  267G  45% /"
}

if [ ! -z $DESMODE ]; then
    descript
    exit 1
fi

#############################
## Summary Real Spec 
#############################

summary() {
    title "CPU INFO"
    CPUS=$(grep ^processor /proc/cpuinfo | wc -l)
    CORES=$(grep 'cpu cores' /proc/cpuinfo | tail -1 | awk '{ print $4 }')
    MODEL=$(grep 'model name' /proc/cpuinfo | tail -1 | cut -f 3- -d ' ')
    echo "CPUS : $CPUS"
    echo "CORES/CPU : $CORES"
    echo "MODEL : $MODEL"

    title "MEMORY INFO"
    WINDOW_CHECK=$(cat /proc/meminfo | grep MemAvailable | awk '{ print $2 }')
    if [ ${#WINDOW_CHECK} -gt 1 ]; then
        TOTAL=$(cat /proc/meminfo | grep MemTotal | awk '{ print $2 }')
        TOTAL_G=$(printf %.1f\\n "$((10*1*$TOTAL/10**7))")
        REALFREE=$(cat /proc/meminfo | grep MemAvailable | awk '{ print $2 }')
        USEAGE=$(printf "$((10**2 * ($TOTAL - $REALFREE) / $TOTAL ))" )
    else
        TOTAL=$(cat /proc/meminfo | grep MemTotal | awk '{ print $2 }')
        TOTAL_G=$(printf %.1f\\n "$((10*1*$TOTAL/10**7))")
        REALFREE=$(cat /proc/meminfo | grep MemFree | awk '{ print $2 }')
        USEAGE=$(printf "$((10**2 * ($TOTAL - $REALFREE) / $TOTAL ))" )
    fi
    echo "MEM : $TOTAL_G GB"
    echo "USE : $USEAGE %"

    title "DISK INFO"
    LINE=$(df -h | wc -l)
    for ((i = 1 ; i <= $LINE ; i++)); do
        echo $(df -h | sed "${i}q;d")
    done
}

summary