#!/bin/sh
if [ "$#" -lt 2 ]; then
	echo 'split.sh in out'
	exit
fi
mkdir $2; parallel "convert {} -format png -alpha off -gravity NorthWest -chop \$(convert {} -format \"%[fx:w%128]x%[fx:h%128]\" info:) +repage -crop 128x128 +repage +adjoin $2/{#}_%d.png" ::: $1/*
