bash <(grep -v bash $0|sed 's/X/done\n/;s/Y/echo /') $1 $2 ; exit 7
S(){
S=''
K=$(sed 's/ /\n/g;s/-//g' <<< $1 | sort -n | uniq)
for k in $K; do 
s=$(fgrep -B5 -A5 "$k" $2|tr -d '\n'|sed 's/ --/\n/g'|sed 's/^[^\.]*\([A-Z\.].\{18,\}\.\).*$/\1/'|shuf -n1)
until [ -z $k ] || [ ! -z "$s" ];do
k=$(sed 's/^.//'<<<"$k")
s=$(fgrep -B5 -A5 "$k" $2|tr -d '\n'|sed 's/ --/\n/g'|sed 's/^[^\.]*\([A-Z\.].\{18,\}\.\).*$/\1/'|shuf -n1)
XS+=$s
XY$S
}
R(){
o=$1
for w in $(egrep -o "\b\w[a-z]{$3,}\b"<<<$1|grep -vi cassandra|shuf -n210);do
o=$(sed "s/$w/$(egrep -o "\b\w[a-z]{$4,}\b" $2|shuf -n1)/g"<<<$o)
XY$o
}
while read l;do
if [ $(wc -m <<<"$l") -gt 40 ];then
l=$(sed "s/----/$(egrep -o "\w[a-z]{7,}" $2|shuf -n1)/g"<<<$l)
g=$(R "$(S "$l" $2)" $1 4 4)
l=$(R "$l" $2 7 7)
sed 's/^\([^\.]*\).*$/\1./'<<<"$l"|tr -d '\n'
if [[ $l =~ "Phoenix" ]];then
g=$(cut -d' ' -f-200<<<"$g")
fi
sed "s/through/thro'/g;s/ful\([^l]\)/full\1/g;s/\band\b/\&/g;s/ien/ein/g"<<<"$g"
sed 's/^[^\.]*\.\(.*\)$/\1/'<<<"$l"
else
sed 's/NOVEL/GENERATED NOVEL/
s/AUTHOR/AUTHORMATON/
s/by \(permission\) \(to\) \(Miss\)/without any \1 whatsoever \2 the \3es/'<<<"$l"
fi
done<$1
