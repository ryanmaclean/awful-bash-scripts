
## yy-mm-dd
date "+%y-%m-%d"

## fancy
date

## fancy with hyphens and underscores
date -r $(date +%s) | tr -s ' ' | tr ' ' '_' | tr ":" "-"
