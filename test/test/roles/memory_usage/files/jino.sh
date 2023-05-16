#!/bin/bash
echo "Memory Usage Details"
echo "--------------------"
echo ""
free | awk '/Mem/{printf("Memory Usage: %.2f%"), $3/$2*100} /buffers\/cache/{printf(", buffers: %.2f%"), $4/($3+$4)*100} /Swap/{printf(", Swap Usage: %.2f%"), $3/$2*100}'
echo ""
echo ""
echo "User Based Memeory Usage:"
echo ""
ps -eo user,pcpu,pmem | tail -n +2 | awk '{num[$1]++; cpu[$1] += $2; mem[$1] += $3} END{printf("NPROC\tUSER\tCPU\tMEM\n"); for (user in cpu) printf("%d\t%s\t%.2f\t%.2f\n",num[user], user, cpu[user], mem[user]) }'
echo ""
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head

