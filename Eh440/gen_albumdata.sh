#!/bin/sh

echo "Download: albumdata.txt"
curl -s  'https://itunes.apple.com/lookup?id=875896750&entity=album' > albumdata.txt 

cat albumdata.txt | jq -r '.results[] | "\(.collectionId)=\(.artworkUrl100)"' | grep -v null | sed "s/100x100/600x600/g" | while read detail; do url=`echo $detail | cut -d'=' -f 2`; name=`echo $detail | cut -d'=' -f 1`; name="album-${name}.jpg"; echo "Download: ${name} ($url)"; curl -s "$url" > ${name}; done


