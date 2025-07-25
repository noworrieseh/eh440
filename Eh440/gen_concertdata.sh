#!/bin/sh

echo "Download: concertdata.txt"
curl -s  'https://api.bandsintown.com/artists/Eh440/events.json?api_version=2.0&app_id=MyTest&date=all' > concertdata.txt 



