#!/usr/bin/env bash
#
# ** THIS FILE IS MANAGED BY PUPPET **
# ** Do not edit manually **
#
profile=$1
epoch=$(date "+%s")

function mail_if_oldsynchro {
    lastsynchro=$(cat /root/.unison/last_synchro/$profile.epoch)
    duration=$(echo "$epoch - $lastsynchro" | bc)
    if [ $duration -gt 86400 ] # last successful synchro > 1 day
    then
        now=$(date "+%d/%m/%y %H:%M")
        echo $output | mail bruno@localhost -s "[unison][$profile] Error ̀$now"
    fi
}

# ensure last_synchro/$profile exists
if [ ! -f /root/.unison/last_synchro/$profile.epoch ]; then
    echo "0" > /root/.unison/last_synchro/$profile.epoch
fi

# test if unison is not already running
trash=$(ps -u root | grep unison)
ret=$?
if [ $ret -eq 0 ]
then
    # unison is already running for this user
    output="unison is already running for this user"
    mail_if_oldsynchro
    exit 1
fi

# test if connexion to srvb is successful
trash=$(ssh srvb pwd)
ret=$?
if [ $ret -ne 0 ]
then
    # connexion has failed
    output="connexion to srvb has failed"
    mail_if_oldsynchro
    exit $ret
fi

# in case of successful connexion, overwrite lastsynchro.epoch
echo $epoch > ~/.unison/lastsynchro.epoch

# process unison
output=$(unison $profile 2>&1) > /dev/null
ret=$?

# send a mail in case of error status
if [ $ret -ne 0 ]
then
    now=$(date "+%d/%m/%y %H:%M")
    echo $output | mail bruno@localhost -s "[unison][$profile] Error ̀$now"
fi

exit 0
