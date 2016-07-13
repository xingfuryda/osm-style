#!/bin/sh

##
# Run Mapbox Studio Classic operations
#

exportsource () {
    echo "exportsource() called"
	export HOME=/home/root
	export MAPNIK_FONT_PATH=$(find /usr/share/fonts/ -type f | sed 's|/[^/]*$$||' | uniq | paste -s -d: -)
	
	/home/root/mapbox-studio-classic/node_modules/.bin/tilelive-copy \
		--scheme=pyramid \
		--bounds=$BOUNDS \
		--minzoom=$MINZOOM \
		--maxzoom=$MAXZOOM \
		bridge:///home/root/projects/openstreetmap-carto-vector-tiles/osm-carto.tm2source/data.xml \
		mbtiles:///home/root/projects/$FILENAME.mbtiles	
	
	sqlite3 /home/root/projects/$FILENAME.mbtiles 'INSERT OR IGNORE INTO metadata VALUES("attribution","&copy; OpenStreetMap contributors")'
	sqlite3 /home/root/projects/$FILENAME.mbtiles 'INSERT OR IGNORE INTO metadata VALUES("scheme","tms")'
	
	a="update metadata set value=\""
	c="\" where name=\"bounds\""
	d=$a$BOUNDS$c
	echo $d
	sqlite3 /home/root/projects/$FILENAME.mbtiles "$d"
	echo "exportsource() done"
}

serve () {
	echo "serve() called"
	echo "delete project.xml after making style changes, as it is cached in tilelive-tmstyle"
	echo "first run is slow while project.xml is built"
	export HOME=/home/root
	export MAPNIK_FONT_PATH=$(find /usr/share/fonts/ -type f | sed 's|/[^/]*$$||' | uniq | paste -s -d: -)	
	
	# update the tm2 project.yml to point to the new mbtiles file
	# todo
	node /home/root/tessera/node_modules/.bin/tessera tmstyle:///home/root/projects/openstreetmap-carto-vector-tiles/osm-carto.tm2	
	echo "serve() done"
}

previewstyling () {
    echo "previewstyling() called"
	export HOME=/home/root
	export MAPNIK_FONT_PATH=$(find /usr/share/fonts/ -type f | sed 's|/[^/]*$$||' | uniq | paste -s -d: -)
	
	node /home/root/mapbox-studio-classic/index.js		
	echo "previewstyling() done"
}

preparestyling () {
	echo "preparestyling() called"
	rm -rfv /home/root/projects/*
	echo "copying project folder..."
	cp -R /home/root/openstreetmap-carto-vector-tiles/ /home/root/projects/
	cd /home/root/projects/openstreetmap-carto-vector-tiles
	
	# insert the PostgreSQL connection params
	python updateConnection.py
	
	make mapbox-studio-classic
	
	export PGPASSWORD=password1
	
	psql \
		--username=postgres \
		--host=store \
		--port=5432 \
		--dbname=gis \
		--file=/home/root/postgis-vt-util/postgis-vt-util.sql
		
	psql \
		--username=postgres \
		--host=store \
		--port=5432 \
		--dbname=gis \
		--file=/home/root/openstreetmap-carto-vector-tiles/indexes.sql
	
	echo "preparestyling() done. Hit Ctrl-C to quit."
}

_wait () {
    WAIT=$1
    NOW=`date +%s`
    BOOT_TIME=`stat -c %X /etc/container_environment.sh`
    UPTIME=`expr $NOW - $BOOT_TIME`
    DELTA=`expr 5 - $UPTIME`
    if [ $DELTA -gt 0 ]
    then
	sleep $DELTA
    fi
}

# Unless there is a terminal attached wait until 5 seconds after boot
# when runit will have started supervising the services.
if ! tty --silent
then
    _wait 5
fi

# Execute the specified command sequence
for arg 
do
    $arg;
done

# Unless there is a terminal attached don't exit, otherwise docker
# will also exit
if ! tty --silent
then
    # Wait forever (see
    # http://unix.stackexchange.com/questions/42901/how-to-do-nothing-forever-in-an-elegant-way).
    tail -f /dev/null
fi
