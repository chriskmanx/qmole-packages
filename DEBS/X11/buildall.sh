#!/bin/bash
for dir in ./uk.qmole.*/
do
    dir=${dir%*/}
    thisdir=${dir##*/}
    echo "Processing " $thisdir
    ./build.sh $thisdir
    dpkg-name $thisdir.deb
done
