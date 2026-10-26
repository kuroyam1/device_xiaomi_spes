#! /vendor/bin/sh
#
# Copyright (c) 2026 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Start the RIL instances only once the modem is online.
#
# qcrild creates its QMI clients when it starts. If it is started while the
# modem is still booting - qcrild used to be started from "on boot" while the
# modem only reported in about a second later - the UIM client misses the card
# and the framework keeps reporting "no SIM" until qcrild is restarted by hand.
#
# Poll the msm_subsys state of the modem, then start both RIL instances.

if [ -d /sys/bus/msm_subsys/devices ]; then
    i=0
    modem_state=

    while [ $i -lt 300 ]; do
        if [ -z "$modem_state" ]; then
            for d in /sys/bus/msm_subsys/devices/subsys*; do
                if [ "$(cat "$d/name" 2>/dev/null)" = "modem" ]; then
                    modem_state="$d/state"
                    break
                fi
            done
        fi

        if [ -n "$modem_state" ] && [ "$(cat "$modem_state" 2>/dev/null)" = "ONLINE" ]; then
            break
        fi

        sleep 0.1
        i=$((i + 1))
    done
fi

# Never leave the radio down: start qcrild even if the modem never reported in.
# Both services are "disabled" in qcrild.rc, so they are only started from here.
setprop ctl.start vendor.qcrild
setprop ctl.start vendor.qcrild2
