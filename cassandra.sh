#!/bin/bash

seedtext=data/cassandra.txt

sourceoneurl=https://archive.org/download/cbarchive_53241_onthemycologyandvisceralanatom1884/onthemycologyandvisceralanatom1884_djvu.txt
sourceone=data/onthemycologyandvisceralanatom1884_djvu.txt

# Get source text file, if not already present
wget -nc -O $sourceone $sourceoneurl 

sentences () {
        sentences=''
	# get a 'sentence' for each keyword in $1 (string) from $2 (filename)
        keywords=$(sed 's/ /\n/g;s/-//g' <<< $1 | sort -n | uniq)
	for keyword in $keywords; do 
	    sentence=$(fgrep -B5 -A5 "$keyword" $2 | tr -d '\n' | sed 's/ --/\n/g' | sed 's/^[^\.]*\([A-Z\.].\{18,\}\.\).*$/\1/'|shuf -n1)
	    until [ -z "$keyword" ] || [ ! -z "$sentence" ] ; do
		keyword=$(sed 's/^.//' <<< "$keyword")
		sentence=$(fgrep -B5 -A5 "$keyword" $2 | tr -d '\n' | sed 's/ --/\n/g' | sed 's/^[^\.]*\([A-Z\.].\{18,\}\.\).*$/\1/'|shuf -n1)
	    done
	    sentences+="$sentence"
	done
        echo "$sentences"
}

###
# For each line in seed text, rewrite if a chapter:

while read line; do
    if [ $(wc -m <<< "$line") -gt 40 ]; then
        echo '[MODIFIED:] '
	sed 's/^\([^\.]*\).*$/\1./' <<< "$line" | tr -d '\n'
	genoutput=$(sentences "$line" $sourceone)
	# Emulate the esteemed style of our original author:
	sed "s/through/thro'/g;s/ful\([^l]\)/full\1/g;s/\band\b/\&/g" <<< "$genoutput"
        sed 's/^[^\.]*\.\(.*\)$/\1/' <<< "$line"
    else
        sed 's/NOVEL/GENERATED NOVEL/
             s/AUTHOR/AUTHORMATON/
	     s/by \(permission\) \(to\) \(Miss\)/without any \1 whatsoever \2 the \3es/' <<< "$line"
    fi
done < $seedtext
