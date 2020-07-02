#!/bin/bash

# random write of a 4GB file written in 4KB blocks for 60 seconds
fio --name=random-write --ioengine=posixaio --rw=randwrite --bs=4k --numjobs=1 --size=4g --iodepth=1 --runtime=60 --time_based --end_fsync=1

# 16 parallel jobs each performing a random write of a 256MB file written in 64KB blocks for 60 seconds
fio --name=random-write --ioengine=posixaio --rw=randwrite --bs=64k --size=256m --numjobs=16 --iodepth=16 --runtime=60 --time_based --end_fsync=1

# random write of a 16GB file written in 1MB blocks for 60 seconds
fio --name=random-write --ioengine=posixaio --rw=randwrite --bs=1m --size=16g --numjobs=1 --iodepth=1 --runtime=60 --time_based --end_fsync=1

# random read/write (75% read to 25% write) of a 4GB file in 4KB blocks
fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test --filename=test --bs=4k --iodepth=64 --size=4G --readwrite=randrw --rwmixread=75

# test latency of IO operations
# should be around 0.2 to 0.4 ms or 200 to 400 us
ioping -c 10 .

echo "Remember to rm the files generated from running this script"
# rm *