#!/bin/bash

# Output of Cassandra script converted to markdown 
./cassandra.sh | sed 's/^\(CHAPTER\|Dedication:\)/## \1/;s/\(THE BEAUTIFULL\)/# \1/'
