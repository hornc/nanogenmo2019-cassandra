#!/bin/bash
e(){
egrep $@
}
h(){
shuf -n1
}
f(){
e -B5 -A5 "$1" $2|tr -d '\n'|sed 's/ --/\n/g;s/^[^\.]*\([A-Z\.].\{18,\}\.\).*$/\1/'|h
}
x(){
sed "$1"<<<$2
}
se(){
S=''
K=$(x 's/ /\n/g;s/-//g' "$1"|sort -n|uniq)
for k in $K; do 
s=$(f $k $2)
until [ -z $k ] || [ ! -z "$s" ];do
k=$(x 's/^.//' $k)
s=$(f $k $2)
done
S+=$s
done
echo $S
}
re(){
o=$1
for w in $(e -o "\b\w[a-z]{$3,}\b"<<<$1|e -vi cass|shuf -n210);do
o=$(x "s/$w/$(e -o "\b\w[a-z]{$4,}\b" $2|h)/g" "$o")
done
echo $o
}
while read l;do
g=''
if [ $(wc -m<<<"$l") -gt 40 ];then
l=$(x "s/-\+/$(e -o "\w[a-z]{7,}" $2|h)/g" "$l")
g=$(re "$(se "$l" $2)" $1 4 4)
l=$(re "$l" $2 7 7)
x 's/^\([^\.]*\).*$/\1./' "$l"|tr -d '\n'
if [[ $l =~ Phoe ]];then
g=$(cut -d' ' -f-200<<<$g)
fi
fi
x "s/\(NOVEL\)/GENERATED \1/;s/\(AUTHOR\)/\1MATON/;s/by \(pe.*\b\) to \(Miss\)/without any \1 whatsoever to the \2es/;s/^[^\.]*\.\(.*\)$/\1/;s/hrough/hro'/g;s/ful\([^l]\)/full\1/g;s/\band\b/\&/g;s/ien/ein/g" "$g$l"
done<$1
