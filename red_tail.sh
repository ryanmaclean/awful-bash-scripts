#!/bin/bash
#Adapted from the answer here: http://unix.stackexchange.com/posts/8417/revisions
$FILENAME = /opt/tomcat/logs/catalina.out
$REDTEXT = error
tail -f $FILENAME | perl -pe 's/.*$REDTEXT.*/\e[1;31m$&\e[0m/g'
