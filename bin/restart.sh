#!/bin/bash

echo
echo "************************************************"
echo
echo "WARNING! This is the INFO instance"
echo
echo "************************************************"

echo
echo "Restarting INFO instance"

echo
read -p "Press [Enter] key ..."

echo
echo "Stopping server"
bin/stop.sh

echo
echo "Starting server"
bin/run.sh