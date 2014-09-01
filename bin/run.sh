#!/bin/bash

TS=`date +%Y_%m_%d_%H_%M_%S`

rm -rf *-$JS-error.log
rm -rf *-$JS-output.log


node_modules/forever/bin/forever start -l $TS-$JS-forever.log -o $TS-$JS-output.log -e $TS-$JS-error.log dist/landing-server.js 7654
