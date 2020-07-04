#!/bin/bash
# Author: Daniel Sokolowski
# source: https://bitbucket.org/snippets/danielsokolowski/G5oeA
# inspired by http://www.commandlinefu.com/commands/view/229/quick-integer-cpu-benchmark, http://serverfault.com/questions/372020/what-are-the-best-possible-ways-to-benchmark-ram-no-ecc-under-linux-arm
# source comment: https://serverfault.com/questions/372020/what-are-the-best-possible-ways-to-benchmark-ram-no-ecc-under-linux-arm#comment1042186_372059

echo "Please be patient, this might take a minute or so."
hostname=$(cat /etc/hostname)
ips=$(hostname --all-ip-addresses)
cname=$(cat /proc/cpuinfo|grep name|head -1|awk '{ $1=$2=$3=""; print }' | xargs)  # xargs left/left trims the string
cores=$(cat /proc/cpuinfo|grep MHz|wc -l | xargs)
freq=$(cat /proc/cpuinfo|grep MHz|head -1|awk '{ print $4 }')
cpuspeed=$( (time echo "scale=5000; a(1)*4" | bc -l > /dev/null) 2>&1 | head --lines=2 | tail --lines=1 | awk -F ' ' '{print $2}')
tram=$(free -m | awk 'NR==2'|awk '{ print $2 }')
swap=$(free -m | awk 'NR==4'| awk '{ print $2 }')
up=$(uptime|awk '{ $1=$2=$(NF-6)=$(NF-5)=$(NF-4)=$(NF-3)=$(NF-2)=$(NF-1)=$NF=""; print }' | xargs) # xargs left/left trims the string

cache="$((wget -O /dev/null http://cachefly.cachefly.net/100mb.test) 2>&1 | tail -2 | head -1 | awk '{print $3 $4 }' | sed 's/^(\(.*\))$/\1/' )"
io=$( (dd if=/dev/zero of=test_$$ bs=1M count=256 conv=fdatasync &&rm -f test_$$) 2>&1 | tail -1| awk '{ print $(NF-1) $NF }')
io2=$( (dd if=/dev/zero of=test_$$ bs=1M count=256 oflag=dsync &&rm -f test_$$) 2>&1 | tail -1| awk '{ print $(NF-1) $NF }')

# memory test
tempDir=`mktemp -d -t linux-benchmark-XXX`
mount -t tmpfs $tempDir $tempDir
io3=$( (dd if=/dev/zero of=$tempDir/test_$$ bs=1M count=2048 conv=fdatasync &&rm -f test_$$) 2>&1 | tail -1| awk '{ print $(NF-1) $NF }')
#io3=$( (dd if=/dev/zero of=$tempDir/test_$$ bs=1M conv=fdatasync &&rm -f test_$$) 2>&1 | tail -1| awk '{ print $(NF-1) $NF }')
umount -f $tempDir
mount -t tmpfs $tempDir $tempDir
io4=$( (dd if=/dev/zero of=$tempDir/test_$$ bs=1M count=2048 oflag=dsync &&rm -f test_$$) 2>&1 | tail -1| awk '{ print $(NF-1) $NF }')
#io4=$( (dd if=/dev/zero of=$tempDir/test_$$ bs=1M oflag=dsync &&rm -f test_$$) 2>&1 | tail -1| awk '{ print $(NF-1) $NF }')
umount -f $tempDir

outputfilename=$(basename $0-run-`date "+%Y.%m.%d-%H.%M.%S".txt`)
echo "Hostname:             $hostname" >> $outputfilename
echo "IP(s):                $ips"  >> $outputfilename
echo "CPU model:            $cname" >> $outputfilename
echo "Number of cores:      $cores" >> $outputfilename
echo "CPU frequency:        $freq MHz" >> $outputfilename
echo "System uptime:        $up" >> $outputfilename
echo "Total amount of ram:  $tram MB" >> $outputfilename
echo "Total amount of swap: $swap MB" >> $outputfilename
echo "Calc PI to 5000:      $cpuspeed"  >> $outputfilename
echo "Download speed:       $cache " >> $outputfilename
echo "HDD I/O (conv=fdatasync): $io" >> $outputfilename
echo "HDD I/O (oflad=dsync):    $io2" >> $outputfilename
echo "Memory I/O (conv=fdatasync): $io3" >> $outputfilename
echo "Memory I/O (oflad=dsync):    $io4" >> $outputfilename

echo ""
cat $outputfilename
echo ""

rm -rf /tmp/linux-benchmark-*