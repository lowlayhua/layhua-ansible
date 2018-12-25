#!/bin/bash
for p in $(cat p.txt)
do
        echo "$p"
        yum install -y $p
done

