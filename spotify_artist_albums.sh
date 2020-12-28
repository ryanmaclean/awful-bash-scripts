#!/usr/bin/env bash

# Example, using Spoon
# TODO: Support artists with spaces in their name :)
ARTIST="spoon"
ARTIST_ID = curl --silent -X GET "https://api.spotify.com/v1/search?q=${ARTIST}&type=artist&limit=1" | jq '.artists.items | .[length-1].id'
ARTIST_ALBUMS = curl --silent -X GET "https://api.spotify.com/v1/artists/${ARTIST_ID}/albums"
