#!/bin/bash

echo
echo "************************************************"
echo
echo "WARNING! This is the INFO instance"
echo
echo "************************************************"

echo
echo "Updating INFO instance"

echo
echo "Pulling from GitHub"
bin/gitpull.sh

echo
echo "Stopping server"
bin/stop.sh

echo
echo "Starting server"
bin/run.sh

echo
