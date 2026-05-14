#!/bin/bash

echo "all variables passed: $@"
echo "number of variables: $#"
echo " script name: $0"
echo "present working directory: $PWD"
echo home directory of current user: $HOME
echo "which user running this script: $USER"
echo "current process id: $$"
sleep 60 &
echo "process id of last background process: $!"
