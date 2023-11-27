Sram22 size/type: 64x4m4w2
==========================

Power results:

The numbers appear to be identical, probably need to investigate further.

![Local Image](/sramtest_images/power_rpt.png)

![Local Image](/sramtest_images/bar_chart.png)

Concurrency: 
```bash
./exec_hammer_lines.sh 1
```
As of now, reports only get written correctly if the commands are executed sequentially. 
That is, if argv[1] = 1. 
Otherwise, there appears to be a lock contention in Joules (or something along these lines). 
The end result is this: some reports do not end up being written on disk, even though the flow goes through.
