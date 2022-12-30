#!/bin/bash
i=1
loop=90
while(( $i <= loop ));
do
    echo "$((i*50))"
    i=$((i + 1))
done