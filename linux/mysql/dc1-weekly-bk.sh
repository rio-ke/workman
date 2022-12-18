#!/bin/bash
#Use = Backup of Important Data

#START

TIME=`date +%Y%b%d\(%a\)%H-%M-%S` # This Command will add date in Backup File Name.
FILENAME=App_Backup-$TIME.tar.gz  # Here i define Backup file name format.
SRCDIR="/webdata" #Location of Important Data Directory (Source of backup).
DESDIR="/mnt/backup/RCMS/weeklybackup"  # Destination of backup file.
tar -cpzf $DESDIR/$FILENAME $SRCDIR

#END 
