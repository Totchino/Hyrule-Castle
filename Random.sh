#!/bin/bash

b=10
while [[ $b -le 0 ]] || [[ $b -ge 6 ]]; do
b=$(($RANDOM%10))
done
echo $b