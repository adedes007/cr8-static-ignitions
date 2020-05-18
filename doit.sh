#!/bin/bash
#cd master0
#../append-xyz.sh master0
#cd ..


for i in bootstrap master0 master1 master2 worker0 worker1 worker2
do
echo Processing  $i ...
cd $i
../append-xyz.sh $i
sleep 1
sed '
s/master0/master/g 
s/master1/master/g 
s/master2/master/g 
s/worker0/worker/g 
s/worker1/worker/g 
s/worker2/worker/g'  <append_$i.json >append-$i.json
sleep 1
rm append_$i.json
cd ..
done

