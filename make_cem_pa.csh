#!/bin/csh
set pp = `pwd`
set nevt = `cat $pp/CEM_files/NA_CLS/CEM_cluster | wc -l`
set nsta = `cat $pp/CEM_files/NA_CLS/CEM_stalist | wc -l`
rm -f CEM_files/NA_MDL/CEM_param
echo $nevt $nsta -1 > CEM_files/NA_MDL/CEM_param
@ i = 1
@ j = 1

while ( $i <= $nsta)
#echo 0.001 0.4 0.29 >> CEM_files/NA_MDL/CEM_param
echo 0.01 0.4 0.29 >> CEM_files/NA_MDL/CEM_param
@ i ++
end

while ( $j <= $nevt)
#echo 0.1 12 9.9 >> CEM_files/NA_MDL/CEM_param
echo 0.1 15 9.9 >> CEM_files/NA_MDL/CEM_param
@ j ++
end

set wkpath = `pwd`
set targ = 'case1'
set datapath = "$wkpath/$targ"

echo '#' > CEM_files/CEM.in
echo '## Input file for CEM specific information' >> CEM_files/CEM.in
echo '#' >> CEM_files/CEM.in
echo "$datapath"  >> CEM_files/CEM.in
echo "CEM_cluster"  >> CEM_files/CEM.in
echo "CEM_stalist"   >> CEM_files/CEM.in
echo "CEM_param"   >> CEM_files/CEM.in
echo "CEM_model"   >> CEM_files/CEM.in

