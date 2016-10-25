#!/usr/bin/env bash

# This command only takes one argument, a filename, 
# and renames the file to the same name as it had previsouly, with .old appended to the end. 

mv $1{,.old}

echo $1 renamed to $1.old
