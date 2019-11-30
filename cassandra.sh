#!/bin/bash

seedtext=data/cassandra.txt

#sourceoneurl=https://archive.org/download/cbarchive_53241_onthemycologyandvisceralanatom1884/onthemycologyandvisceralanatom1884_djvu.txt
#sourceone=data/onthemycologyandvisceralanatom1884_djvu.txt

sourceoneurl=https://archive.org/download/kinginyellow00chamrich/kinginyellow00chamrich_djvu.txt
sourceone=data/kinginyellow00chamrich_djvu.txt


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

# replace words from $1 with words in $2 file
replace () {
	out=$1
        for w in $(egrep -o "\b\w[a-z]{$3,}\b" <<< $1| grep -vi cassandra | shuf -n210); do
		out=$(sed "s/$w/$(egrep -o "\b\w[a-z]{$4,}\b" $2 | shuf -n1)/g" <<< $out)
	done
	echo "$out"
}

###
# For each line in seed text, rewrite if a chapter:

while read line; do
    if [ $(wc -m <<< "$line") -gt 40 ]; then
	line=$(sed "s/----/$(egrep -o "\w[a-z]{7,}" $sourceone | shuf -n1)/g" <<< $line)
        genoutput=$(replace "$(sentences "$line" $sourceone)" data/cassandra.txt 4 4)
	line=$(replace "$line" $sourceone 7 7)
	sed 's/^\([^\.]*\).*$/\1./' <<< "$line" | tr -d '\n'
	if [[ $line =~ "Phoenix" ]]; then
		# truncate the dedication
		genoutput=$(cut -d' ' -f-200 <<< "$genoutput")
	fi
	# Emulate the esteemed style of our original author:
	sed "s/through/thro'/g;s/ful\([^l]\)/full\1/g;s/\band\b/\&/g;s/ien/ein/g" <<< "$genoutput"
        sed 's/^[^\.]*\.\(.*\)$/\1/' <<< "$line"
    else
        sed 's/NOVEL/GENERATED NOVEL/
             s/AUTHOR/AUTHORMATON/
	     s/by \(permission\) \(to\) \(Miss\)/without any \1 whatsoever \2 the \3es/' <<< "$line"
    fi
done < $seedtext
