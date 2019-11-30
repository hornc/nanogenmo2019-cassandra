#!/bin/bash
h () {
shuf -n1
}
f () {
fgrep -B5 -A5 "$1" $2|tr -d '\n'|sed 's/ --/\n/g;s/^[^\.]*\([A-Z\.].\{18,\}\.\).*$/\1/'|h
}
se () {
S=''
K=$(sed 's/ /\n/g;s/-//g'<<<$1|sort -n|uniq)
for k in $K; do 
s=$(f $k $2)
until [ -z "$k" ] || [ ! -z "$s" ];do
k=$(sed 's/^.//'<<<$k)
s=$(f $k $2)
done
S+=$s
done
echo $S
}
re () {
o=$1
for w in $(egrep -o "\b\w[a-z]{$3,}\b"<<<$1|grep -vi cassandra|shuf -n210);do
o=$(sed "s/$w/$(egrep -o "\b\w[a-z]{$4,}\b" $2|h)/g"<<<$o)
done
echo $o
}
while read l;do
if [ $(wc -m<<<"$l") -gt 40 ];then
l=$(sed "s/----/$(egrep -o "\w[a-z]{7,}" $2|h)/g"<<<$l)
g=$(re "$(se "$l" $2 )" $1 4 4)
l=$(re "$l" $2 7 7)
sed 's/^\([^\.]*\).*$/\1./'<<<$l|tr -d '\n'
if [[ $l =~ "Phoenix" ]];then
g=$(cut -d' ' -f-200<<<$g)
fi
sed "s/through/thro'/g;s/ful\([^l]\)/full\1/g;s/\band\b/\&/g;s/ien/ein/g"<<<$g
sed 's/^[^\.]*\.\(.*\)$/\1/'<<<$l
else
sed 's/\(NOVEL\)/GENERATED \1/
s/\(AUTHOR\)/\1MATON/
s/by \(pe.*\b\) \(to\) \(Miss\)/without any \1 whatsoever \2 the \3es/'<<<$l
fi
done<$1
