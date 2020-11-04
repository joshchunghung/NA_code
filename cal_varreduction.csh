#!/bin/csh
#  1-(Vdata/Vmodel)
#
rm -f *.var.log
set kk = $1
set file = `awk '{print $1}' $kk/sum.txt | sort -u` 
foreach ff ($file)
set k = `awk '($1==a){print $2}' a=$ff $kk/sum.txt`
foreach sta ($k)
set yy = `ls $kk/case1/$ff/{$sta}amp.out`
awk '($1==a && $2== b){print $3,$4,$5}' a=$ff b=$sta $kk/sum.txt > g.log
~/cem1/program/varmodel<<!>&/dev/null
$yy
g.log
!
cat var.log >> $kk.var.log
rm -f var.log
rm -f g.log
end
end

set vdata = `awk '{sum += $1} END {print sum}' $kk.var.log`
set vmodel = `awk '{sum += $2} END {print sum}' $kk.var.log`
set var_reduction = `echo $vdata $vmodel | awk '{printf "%6.2f%",(1-($2/$1))*100}'`
echo $kk $var_reduction 
echo $kk $var_reduction >> var.clu.txt
echo  $var_reduction > var.reduct.txt
mv $kk.var.log $kk/
mv var.reduct.txt $kk/

