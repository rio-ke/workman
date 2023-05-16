
SSHD=/etc/ssh/sshd_config
#OUTPUT=/tmp/ISEC_SSH_`uname -n`.`date +%m%d%y`.output.txt
#SUB variable is used in the ShouldNot_Comment function to determine which routines
#to run dependent on the number of variables to check. 
#Setting of 0 means 1 variable to check which is the default.
SUB=0
FOUND=1

LOGFILE=/tmp/ssh.txt
LOGFILE=/tmp/file1.txt
if [ `id -unr` = "root" ]; then
   if [ -f /etc/redhat-release ]; then 
      OSFlavor=RedHat
   elif [ -f /etc/SuSE-release ]; then
      OSFlavor=SuSE
   else
      exit
   fi
else
   exit 1
fi


if [ -f /etc/redhat-release ]; then 
   cat /etc/redhat-release >> $LOGFILE
       RHVER=`sed -rn 's/.*([0-9])\.[0-9].*/\1/p' /etc/redhat-release`
#   grep -q Enterprise /etc/redhat-release
#   if (($?)); then
#      RHVER=`awk '{print $5}' /etc/redhat-release | cut -c1`
#   else
#      RHVER=`awk '{print $3}' /etc/redhat-release | cut -c1`
#   fi
elif [ -f /etc/SuSE-release ]; then
   cat /etc/SuSE-release >> $LOGFILE
   SVER=`cat /etc/SuSE-release | grep "VERSION" | awk '{print $3}'`
else
   RHVER=X
   SVER=X
fi


###################################################
# Functions are here:
###################################################
ShouldNot_Comment () {
CHECK=0
NUMINST=`/bin/grep -w $VAL $SSHD | /bin/grep -v grep | /bin/grep -wv and | grep -vw regenerates | grep -vw pass | grep -vw setting | grep -vw Uncomment | grep -vw versions | wc -l`
if [ $NUMINST -gt 1 ]; then
	echo "WARNING - More than one entry of $VAL was found in $SSHD"
	echo "WARNING - The $SSHD file MAY need to be checked manually and cleaned up!"
fi
/bin/grep -w $VAL $SSHD | /bin/grep -v grep | /bin/grep -vw and | grep -vw regenerates | grep -vw pass | grep -vw setting | grep -vw Uncomment | grep -vw versions > /dev/null 2>&1
if [ $? -eq 0 ]; then
	/bin/grep -w $VAL $SSHD | /bin/grep -v grep | /bin/grep -v and | grep -vw regenerates | grep -vw pass | grep -vw setting | grep -vw Uncomment | grep -vw versions >> $LOGFILE
	/bin/grep -w $VAL $SSHD | /bin/grep -v "^#" | /bin/grep -v grep | grep -vw regenerates | grep -vw pass | /bin/grep -vw and | grep -vw setting | grep -vw Uncomment | grep -vw versions > /dev/null 2>&1
		if [ $? -eq 1 ]; then
			CHECK=1
			echo "The above line should not be #ed out" 
		fi
	TEST=`/bin/grep -w $VAL $SSHD | /bin/grep -vw and | grep -vw regenerates | grep -vw pass | grep -vw setting | grep -vw Uncomment | grep -vw versions | awk '{print $2}' | head -1`
	if [ $SUB -eq 0 ]; then
		if [ $TEST != $VAL2 ]; then
			echo "The above line should be set to $VAL2"
			CHECK=1
		fi
	elif [ $SUB -eq 1 ]; then
		if [ $TEST != $VAL2 ] && [ $TEST != $VAL3 ] && [ $TEST != $VAL4 ]; then
			echo "The above line should be set to $VAL2 or $VAL3 or $VAL4"
			CHECK=1
		fi
	elif [ $SUB -eq 3 ]; then
	   if ((!$?)); then
	      TEST=`echo $TEST | awk -F":" '{print $NF}'`
	   fi
		VAL3a=`echo $VAL3 | tr -d [[:alpha:]]`
		VAL3b=`echo $VAL3 | tr -d [[:digit:]]`
		TESTa=`echo $TEST | tr -d [[:alpha:]]`
		TESTb=`echo $TEST | tr -d [[:digit:]]`
		if [[ $TESTb = *[$VAL3b] ]] || [[ -z $TESTb ]] && [ $TESTa -le $VAL3a ]; then
			CHECK=$CHECK
		else
			CHECK=1
        		echo "The above line should bet set to a Max value of of $VAL2"
		fi		
	fi

else
	CHECK=1
	echo " WARNING - $VAL setting not found in $SSHD"
fi
if [ $CHECK -eq 0 ]; then
	echo "	$VAL is set correctly"
else
	echo "	WARNING - $VAL is NOT configured correctly."
fi
#SUB set back to 0 to run standard
SUB=0
return
} #ShouldNot_Comment

Should_Comment () {
CHECK=0
NUMINST=`/bin/grep -w $VAL $SSHD | /bin/grep -v grep | /bin/grep -vw and | grep -vw regenerates | grep -vw pass | grep -vw setting | grep -vw Uncomment | grep -vw versions | wc -l`
if [ $NUMINST -gt 1 ]; then
	echo "WARNING - More than one entry of $VAL was found in $SSHD"
	echo "WARNING - The $SSHD file MAY need to be checked manually and cleaned up!"
fi
/bin/grep -w $VAL $SSHD | /bin/grep -v grep | /bin/grep -vw and | grep -vw regenerates | grep -vw setting | grep -vw Uncomment | grep -vw versions | grep -vw pass > /dev/null 2>&1
if [ $? -eq 0 ]; then
	/bin/grep -w $VAL $SSHD | /bin/grep -v grep | /bin/grep -vw and | grep -vw regenerates | grep -vw pass | grep -vw setting | grep -vw Uncomment | grep -vw versions >> $LOGFILE
	if [ $NUMINST -gt 1 ]; then
	   /bin/grep -w $VAL $SSHD | /bin/grep -vw and | grep -vw pass | grep -vw regenerates | grep -vw setting | grep -vw Uncomment | grep -vw versions | grep -vw pass | grep -v "^#" > /dev/null 2>&1
	   if ((!$?)); then
	      TEST=`/bin/grep -w $VAL $SSHD | /bin/grep -vw and | grep -vw regenerates | grep -vw pass | grep -vw setting | grep -vw Uncomment | grep -vw versions | grep -vw pass | grep -v "^#" | tail -1 | awk '{print $2}'`
	   else
	      TEST=`/bin/grep -w $VAL $SSHD | /bin/grep -vw and | grep -vw regenerates | grep -vw pass | grep -vw setting | grep -vw Uncomment | grep -vw versions | grep -vw pass | tail -1 | awk '{print $2}'`
	   fi
	else
	   TEST=`/bin/grep -w $VAL $SSHD | /bin/grep -vw and | grep -vw regenerates | grep -vw pass | grep -vw setting | grep -vw Uncomment | grep -vw versions | grep -vw pass | awk '{print $2}'`
	fi
	if [ $SUB -eq 0 ]; then
	   /bin/grep -w $VAL $SSHD | /bin/grep -v "^#" | grep -vw regenerates | /bin/grep -v grep | /bin/grep -vw and | grep -vw setting | grep -vw Uncomment | grep -vw versions | grep -vw pass > /dev/null 2>&1
		if [ $? -eq 0 ] && [ $TEST != $VAL2 ]; then
			echo "The above line should be #ed out or set to $VAL2"
			CHECK=1
		fi
	elif [ $SUB -eq 1 ]; then
	   /bin/grep -w $VAL $SSHD | /bin/grep -v "^#" | /bin/grep -v grep | grep -vw regenerates | /bin/grep -vw and | grep -vw pass | grep -vw setting | grep -vw Uncomment | grep -vw versions > /dev/null 2>&1
		if [ $? -eq 0 ] && [ $TEST != $VAL2 ] && [ $TEST != $VAL3 ] && [ $TEST != $VAL4 ]; then
			echo "The above line should be #ed out or set to $VAL2 or $VAL3 or $VAL4"
			CHECK=1
		fi
	elif [ $SUB -eq 3 ]; then
	   echo $TEST | grep ":" > /dev/null 2>&1
	   if ((!$?)); then
	      TEST=`echo $TEST | awk -F":" '{print $NF}'`
	   fi
		VAL3a=`echo $VAL3 | tr -d [[:alpha:]]`
		VAL3b=`echo $VAL3 | tr -d [[:digit:]]`
		TESTa=`echo $TEST | tr -d [[:alpha:]]`
		TESTb=`echo $TEST | tr -d [[:digit:]]`
		/bin/grep -w $VAL $SSHD | /bin/grep -v "^#" | /bin/grep -v grep | /bin/grep -vw and | grep -vw regenerates | grep -vw pass | grep -vw setting | grep -vw Uncomment | grep -vw versions > /dev/null 2>&1
		if [ $? -eq 0 ] || [[ $TESTb = *[$VAL3b] ]] || [[ -z $TESTb ]] && [ $TESTa -le $VAL3a ]; then
			CHECK=$CHECK
		else
			CHECK=1
        		echo "The above line should bet #ed out or set to a Max value of $VAL2"
		fi
	elif [ $SUB -eq 4 ]; then
	   echo $TEST | grep "h" > /dev/null 2>&1
	   if ((!$?)); then
	      HOURS=0
	   else
	      HOURS=1
	   fi
		VAL3a=`echo $VAL3 | tr -d [[:alpha:]]`
		VAL3b=`echo $VAL3 | tr -d [[:digit:]]`
		VAL4a=`echo $VAL4 | tr -d [[:alpha:]]`
		VAL4b=`echo $VAL4 | tr -d [[:digit:]]`
		TESTa=`echo $TEST | tr -d [[:alpha:]]`
		TESTb=`echo $TEST | tr -d [[:digit:]]`
		if ((!$HOURS)); then
   		/bin/grep -w $VAL $SSHD | /bin/grep -v "^#" | /bin/grep -v grep | /bin/grep -vw and | grep -vw regenerates | grep -vw pass | grep -vw setting | grep -vw Uncomment | grep -vw versions > /dev/null 2>&1
   		if [ $? -eq 0 ] || [[ $TESTb = *[$VAL3b] ]] || [[ -z $TESTb ]] && [ $TESTa -le $VAL3a ]; then
   			CHECK=$CHECK
   		else
   			CHECK=1
           		echo "The above line should bet #ed out or set to a Max value of $VAL2 or $VAL4"
   		fi
		else
		   /bin/grep -w $VAL $SSHD | /bin/grep -v "^#" | /bin/grep -v grep | /bin/grep -vw and | grep -vw regenerates | grep -vw pass | grep -vw setting | grep -vw Uncomment | grep -vw versions > /dev/null 2>&1
   		if [ $? -eq 0 ] || [[ $TESTb = *[$VAL3b] ]] || [[ -z $TESTb ]] && [ $TESTa -le $VAL4a ]; then
   			CHECK=$CHECK
   		else
   			CHECK=1
           		echo "The above line should bet #ed out or set to a Max value of $VAL2 or $VAL4"
   		fi
      fi
	fi
else
	CHECK=0
	echo " $VAL was not found in $SSHD so it should be ok."
fi
if [ $CHECK -eq 0 ]; then
	echo "	$VAL is set correctly"
else
	echo "	WARNING - $VAL is NOT configured correctly."
fi
#SUB set back to 0 to run standard
SUB=0
return
} #Should_Comment

SSHD_Answer () {
MsgAnswer=1
until [ "$MsgAnswer" = "y" ] || [ "$MsgAnswer" = "Y" ] || [ "$MsgAnswer" = "n" ] || [ "$MsgAnswer" = "N" ]
do
   echo 1 > /tmp/isec_question_prompt
   sleep 6
	echo
	echo "WARNING - The sshd_config file cannot be found at: $SSHD or /usr/local/etc/sshd_config"
	echo "Do you know where it is installed? (y/n)\c"
	read MsgAnswer
done

case $MsgAnswer in
y|Y)
	echo
	echo "Plese enter the FULL path of the sshd_config file."
	echo "For example:  /blah/blah/something/sshd_config"
	echo "What is the FULL path of the sudoers file: \c"
	read SSHD_Path
	SSHD=$SSHD_Path
	echo "User entered the sshd_config path to be: $SSHD"
	echo
	echo 0 > /tmp/isec_question_prompt
	SSHD_Check;
;;
n|N)
	echo
	echo "WARNING - Cannot read the sshd_config file to check the iSeC compliance settings!"
	echo " "
	echo "	*** WARNING - ssh compliance checking has not taken place!!! ***"
	echo " "
	echo "Skipping to the sudo iSeC compliance checking"
	FOUND=1
	echo 0 > /tmp/isec_question_prompt
	echo
;;
esac
} #SSHD_Answer

SSHD_Check () {
if [ -f $SSHD ]; then
	echo "The sshd_config file has been found:  $SSHD"
	#Run the rest of the ssh portion of the script
	FOUND=0
elif [ -f /usr/local/etc/sshd_config ]; then
	SSHD=/usr/local/etc/sshd_config
	echo "The sshd_config file has been found: $SSHD"
	#Run the rest of the ssh portion of the script
	FOUND=0
else
	if ((!$INTERSIL)); then
		SSHD_Answer;
	elif ((!$TADDMSIL)); then
	   echo 1 > /tmp/isec_question_prompt
	   sleep 5
		echo
		echo "WARNING - Cannot read the sshd_config file to check the iSeC compliance settings!"
		echo " "
		echo "	*** WARNING - ssh compliance checking has not taken place!!! ***"
		echo " "
		echo "Skipping to the sudo iSeC compliance checking"
		FOUND=1
		echo
		echo 0 > /tmp/isec_question_prompt
   else
      echo "WARNING - Cannot read the sshd_config file to check the iSeC compliance settings!" >> $LOGFILE
		echo " " >> $LOGFILE
		echo "	*** WARNING - ssh compliance checking has not taken place!!! ***" >> $LOGFILE
		echo " " >> $LOGFILE
		echo "Skipping to the sudo iSeC compliance checking" >> $LOGFILE
		FOUND=1
	fi
fi
} #SSHD_Check


###################################################
# Body of the script begins here:
###################################################

#Get our SSH version:
SSHBinaryFound=0
echo " 	Checking version of SSH "
ssh -V > /dev/null 2>&1
if ((!$?)); then
   SSH_VERSION=`ssh -V 2>&1`
   echo $SSH_VERSION
elif [ -x /usr/bin/ssh ]; then
   SSH_VERSION=`/usr/bin/ssh -V 2>&1`
   echo $SSH_VERSION
elif [ -x /usr/local/bin/ssh ]; then
   SSH_VERSION=`/usr/local/bin/ssh -V 2>&1`
   echo $SSH_VERSION
else
   echo "WARNING - The ssh binary could not be found"
   echo "WARNING - Cannot determine ssh version!"
   SSHBinaryFound=1
fi

#Determine what SSH package is installed & version info...
SunSSHInstalled=1
OpenSSHInstalled=1
if ((!$SSHBinaryFound)); then
   echo $SSH_VERSION | grep -i openssh > /dev/null 2>&1
   if (($?)); then
      echo $SSH_VERSION | grep -i "Sun_SSH" > /dev/null 2>&1
      if (($?)); then
         echo "WARNING - Unable to determine what SSH package is installed!" | tee -a $LOGFILE
      else
         SSHver=`echo $SSH_VERSION | awk '{print $1}' | awk -F'_' '{print $3}' | cut -d',' -f1`
         SSHtype="Sun_SSH"
         echo "This server is running $SSHtype version $SSHver"
         SunSSHInstalled=0
      fi
   else
      SSHver=`echo $SSH_VERSION | awk '{print $1}' | awk -F'_' '{print $2}' | cut -d',' -f1 | cut -c1-3`
      SSHtype="OpenSSH"
      echo "This server is running $SSHtype version $SSHver"
      OpenSSHInstalled=0
   fi
fi

#We need to set our SSH version to only one decimal as some use x.x.x or more which we can't do comparisons with.
BaseSSHver=`echo $SSHver | cut -c1-3`

#Verify sshd_config file exists where expected:
SSHD_Check;

#If the sshd_config file was found then we continue below:
if [ $FOUND -eq 0 ]; then
echo "             ## Checking SSH setting ##"

echo " 	"
echo "CNL_SSH.1.1.1 : Checking PermitEmptyPasswords from $SSHD"
#Special check for SunSSH only:
SPECIALcheck=1
if ((!$SunSSHInstalled)); then
   if [ -f /etc/default/login ]; then
      grep "PASSREQ=NO" /etc/default/login | grep -v "^#" > /dev/null 2>&1
      if ((!$?)); then
         echo "CNL_SSH.1.1.1 : WARNING - PASSREQ=NO exists in /etc/default/login!"
         echo "CNL_SSH.1.1.1 : PermitEmptyPasswords should NOT be #ed out and set to no"
         VAL=PermitEmptyPasswords
         VAL2=no
         ShouldNot_Comment;
         SPECIALcheck=0
      fi
   fi
fi
if (($SPECIALcheck)); then
   echo "CNL_SSH.1.1.1 : This line should be #ed out or set to no"
   VAL=PermitEmptyPasswords
   VAL2=no
   Should_Comment;
fi

echo " "
echo "CNL_SSH.1.1.2 : N/A - This server uses $SSHtype"
echo " "

echo " "
echo "CNL_SSH.1.1.3 : N/A - This server uses $SSHtype"
echo " "

echo "CNL_SSH.1.2.1.2 : Checking LogLevel from $SSHD"
echo "CNL_SSH.1.2.1.2 : This line should be #ed out OR set to INFO or higher "
VAL=LogLevel
# SUB set to 2 so it won't do the VAL2 check since it can be set a number of things that are all ok
SUB=2
Should_Comment;

echo ""
echo "CNL_SSH.1.2.1.3 : Checking LogLevel from $SSHD"
echo "CNL_SSH.1.2.1.3 : This line should be #ed out OR set to INFO or higher "
VAL=LogLevel
# SUB set to 2 so it won't do the VAL2 check since it can be set a number of things that are all ok
SUB=2
Should_Comment;

echo ""
echo "CNL_SSH.1.2.2 : N/A - This server uses $SSHtype"
echo " "

Z=1
until [ $Z -eq 7 ]
do
echo " "
echo "CNL_SSH.1.2.3.$Z : N/A - This server uses $SSHtype"
echo " "
((Z+=1))
done

Z=1
until [ $Z -eq 5 ]
do
echo " "
echo "CNL_SSH.1.2.4.$Z : N/A - This server uses $SSHtype"
echo " "
((Z+=1))
done

echo ""
ShowLogList=1
if [ -f /etc/cron.daily/logrotate ]; then
   if [ -f /etc/logrotate.conf ]; then
      grep "^rotate" /etc/logrotate.conf > /dev/null 2>&1
      if ((!$?)); then
         RotateDays=`grep "^rotate" /etc/logrotate.conf | awk '{print $2}' | head -1`
         if [ $RotateDays -lt 13 ]; then
            echo "CNL_SSH.1.2.4 : WARNING - The system is NOT keeping 90 days worth of log files. It is only keeping $RotateDays week(s) of log files."
         else
            echo "CNL_SSH.1.2.4 : The system is keeping at least 90 days worth of log files."
            grep "^rotate" /etc/logrotate.conf | head -1 >> $LOGFILE
         fi
      else
         echo "CNL_SSH.1.2.4 : WARNING - The rotate paramter is not set in /etc/logrotate.conf!"
         ShowLogList=0
      fi
   else
      echo "CNL_SSH.1.2.4 : WARNING - The /etc/logrotate.conf file does not exist!"
      ShowLogList=0
   fi
else
   echo "CNL_SSH.1.2.4 : WARNING - The /etc/cron.daily/logrotate file does not exist!"
   ShowLogList=0
fi
if ((!$ShowLogList)); then
   echo "CNL_SSH.1.2.4 : Here is a long listing of the system log files. Ensure there are at least 90 days worth:"
   for file in messages secure wtmp faillog
   do
   ls -al /var/log/$file | awk '{print $9,"==== "$6,$7,$8}' >> $LOGFILE
   done
fi

echo " "
#Crazy decimal comparisons require a bit more logic....
SSHverCompare=`echo "if ( $BaseSSHver <= 3.7) 1" | bc`
if [[ -z $SSHverCompare ]]; then
        SSHverCompare=0
fi
if (( $OpenSSHInstalled==0 && $SSHverCompare==1 )) || ((!$SunSSHInstalled)); then
   echo "CNL_SSH.1.4.1 : Checking KeepAlive from $SSHD"
   echo "CNL_SSH.1.4.1 : This line SHOULD be #ed out OR set to yes"
   VAL=keepalive
   VAL2=yes
   Should_Comment;
else
   echo "CNL_SSH.1.4.1 : N/A - This server uses $SSHtype $SSHver"
fi

echo " 	" 
SSHverCompare=`echo "if ( $BaseSSHver >= 3.8) 1" | bc`
if [[ -z $SSHverCompare ]]; then
        SSHverCompare=0
fi
if (( $OpenSSHInstalled==0 && $SSHverCompare==1 )); then
   echo "CNL_SSH.1.4.2 : Checking TCPKeepAlive from $SSHD"
   echo "CNL_SSH.1.4.2 : This line SHOULD be #ed out OR set to yes"
   VAL=TCPKeepAlive
   VAL2=yes
   Should_Comment;
else
   echo "CNL_SSH.1.4.2 : N/A - This server uses $SSHtype $SSHver"
fi

echo " 	" 
echo "CNL_SSH.1.4.3 : Checking LoginGraceTime from $SSHD"
echo "CNL_SSH.1.4.3 : This line should be #ed out OR set to Max of 2mins (2m) or 120 seconds"
VAL=LoginGraceTime
VAL2=2m
#This is our max value integer including minutes or seconds
VAL3=2ms
#Set SUB to 3 so it will do a max check
SUB=3
Should_Comment;

#MaxConnections
echo " "
echo "CNL_SSH.1.4.4 : N/A - This server uses $SSHtype $SSHver"

echo " 	"
echo "CNL_SSH.1.4.5 : Checking MaxStartups from $SSHD"
echo "CNL_SSH.1.4.5 : This line should be #ed out which defaults to 10 OR set to max of 100"
VAL=MaxStartups
VAL2=100
#This is our max value
VAL3=100
#Set SUB to 3 so it will do a max check
SUB=3
Should_Comment;

#KeepAlive - VanDyke VShell Only
echo " "
echo "CNL_SSH.1.4.6 : N/A - This server uses $SSHtype $SSHver"

#Authentication Timeout - VanDyke VShell Only
echo " "
echo "CNL_SSH.1.4.7 : N/A - This server uses $SSHtype $SSHver"

echo " 	"
SSHverCompare=`echo "if ( $BaseSSHver >= 3.9) 1" | bc`
if [[ -z $SSHverCompare ]]; then
        SSHverCompare=0
fi
if (( $OpenSSHInstalled==0 && $SSHverCompare==1 )); then
   echo "CNL_SSH.1.4.8 : Checking MaxAuthTries from $SSHD"
   echo "CNL_SSH.1.4.8 : This line should NOT be #ed out and set to max of 5"
   VAL=MaxAuthTries
   VAL2=5
   #This is our max value
   VAL3=5
   #Set SUB to 3 so it will do a max check
   SUB=3
   ShouldNot_Comment;
else
   echo "CNL_SSH.1.4.8 : N/A - This server uses $SSHtype $SSHver"
fi

#Maximum Authentication Retries - VanDyke VShell Only
echo " "
echo "CNL_SSH.1.4.9 : N/A - This server uses $SSHtype $SSHver"

#Bitvise and/or Attachmate Only
Z=10
until [ $Z -eq 19 ]
do
echo " "
echo "CNL_SSH.1.4.$Z : N/A - This server uses $SSHtype"
echo " "
((Z+=1))
done

echo " 	"
echo "CNL_SSH.1.5.1 : Checking KeyRegenerationInterval from $SSHD"
echo "CNL_SSH.1.5.1 : This line should be #ed out OR set to Max of 1 hour (1h) or 3600 seconds and must NOT be 0"
VAL=KeyRegenerationInterval
VAL2=1h
#This is our max integer value including h, m or s
VAL3=1hms
#This one can also be set in seconds, so 2 variables:
VAL4=3600
#Set SUB to 4 so it will do a max check with 2 variables
SUB=4
Should_Comment;

echo " 	" 
echo "CNL_SSH.1.5.2 : Checking Protocol from $SSHD"
echo "CNL_SSH.1.5.2 : The SSH protocol(s) that are accepted by the server. SSH Protocol 1 is known to contain inherent weaknesses."
echo "CNL_SSH.1.5.2 : Therefore, Protocol 2 must be enabled. Protocol 1 is permissible only in situations where"
echo "CNL_SSH.1.5.2 : interoperability issues prevent the use of Protocol 2."
echo "CNL_SSH.1.5.2 : This line should be #ed out OR Recommended setting '2', '2,1' or '1,2' "
echo "CNL_SSH.1.5.2 : If commented out it defaults to 2,1"
#SUB set to 1 so it can do multiple comparisons since multiple values are allowed
SUB=1
VAL=Protocol
VAL2=2
VAL3=2,1
VAL4=1,2
Should_Comment;

#SSH1ServerKeyTime - RemotelyAnywhere Only
echo " "
echo "CNL_SSH.1.5.3 : N/A - This server uses $SSHtype $SSHver"

#SSH2 - RemotelyAnywhere Only
echo " "
echo "CNL_SSH.1.5.4 : N/A - This server uses $SSHtype $SSHver"

echo " 	"
echo "CNL_SSH.1.5.5 : Checking GatewayPorts from $SSHD"
echo "CNL_SSH.1.5.5 : This line SHOULD be #ed out and/or set to no"
VAL=GatewayPorts
VAL2=no
Should_Comment;

#Bitvise WinSSHD Only
echo ""
echo "CNL_SSH.1.5.6 : N/A - This server uses $SSHtype"

#Attachmate Windows Only
echo ""
echo "CNL_SSH.1.5.7 : N/A - This server uses $SSHtype"

echo " "
echo "CNL_SSH.1.7.1.1 : Checking PermitRootLogin from $SSHD"
echo "CNL_SSH.1.7.1.1 : This line should NOT be #ed and set to no"
VAL=PermitRootLogin
VAL2=no
ShouldNot_Comment;

#Public key authentication, location of private keys
echo " "
VAL=PermitRootLogin
VAL2=no
ShouldNot_Comment;
echo "CNL_SSH.1.7.1.2 : THIS SCRIPT CANNOT CHECK THIS SECTION!"

#Public key authentication, required bit length
echo " "
echo "CNL_SSH.1.7.2 : THIS SCRIPT CANNOT CHECK THIS SECTION!"

echo " 	"
echo "CNL_SSH.1.7.3.1 : Checking HostbasedAuthentication from $SSHD"
echo "CNL_SSH.1.7.3.1 : If set to 'yes', all hosts accessed are subject to the requirements of this document."
VAL=HostbasedAuthentication
VAL2=no
Should_Comment;

echo " 	"
echo "CNL_SSH.1.7.3.2 : Checking HostbasedAuthentication from $SSHD"
echo "CNL_SSH.1.7.3.2 : If set to 'yes', /etc/hosts.equiv must not be used. "
VAL=HostbasedAuthentication
VAL2=no
Should_Comment;
if [ -s /etc/hosts.equiv ]; then
   echo "CNL_SSH.1.7.3.2 : WARNING - The /etc/hosts.equiv file exists and contains data!"
else
   echo "CNL_SSH.1.7.3.2 : The /etc/hosts.equiv file does NOT exist"
fi

echo " 	"
echo "CNL_SSH.1.7.3.3 : Checking HostbasedAuthentication from $SSHD"
echo "CNL_SSH.1.7.3.3 : If not #ed AND set to 'yes', /etc/shosts.equiv MUST be used. "
VAL=HostbasedAuthentication
VAL2=no
Should_Comment;
grep "^HostbasedAuthentication" $SSHD | grep "yes" > /dev/null 2>&1
if ((!$?)); then
   if [ ! -s /etc/shosts.equiv ]; then
      echo "CNL_SSH.1.7.3.3 : WARNING - The /etc/shosts.equiv file does NOT exist or contain data!"
   else
      echo "CNL_SSH.1.7.3.3 : The /etc/shosts.equiv file exists"
   fi
else
   echo "CNL_SSH.1.7.3.3 : N/A - HostbasedAuthentication is not enabled"
fi

echo " 	"
echo "CNL_SSH.1.7.4 : Checking PubkeyAuthentication from $SSHD"
echo "CNL_SSH.1.7.4 : If set to 'yes', the requirements in the 'Public Key Authentication' section must be applied."
echo "CNL_SSH.1.7.4 : The default is 'yes' for OpenSSH and SunSSH and valid only if Protocol version 2 is enabled"
VAL=PubkeyAuthentication
VAL2=no
ShouldNot_Comment;

echo " 	"
echo "CNL_SSH.1.7.5 : Checking RSAAuthentication from $SSHD"
echo "CNL_SSH.1.7.5 : If set to 'yes', the requirements in the 'Public Key Authentication' section must be applied. "
echo "CNL_SSH.1.7.5 : The default is 'yes' for OpenSSH and SunSSH and valid only if Protocol version 1 is enabled"
VAL=RSAAuthentication
VAL2=no
ShouldNot_Comment;

echo " 	"
echo "CNL_SSH.1.7.6 : Checking HostbasedAuthentication from $SSHD"
echo "CNL_SSH.1.7.6 : If set to 'yes', the requirements in the 'Host-Based' section must be applied. "
VAL=HostbasedAuthentication
VAL2=no
Should_Comment;

#AllowedAuthentications - F-Secure and SSH Communications Only
echo " "
echo "CNL_SSH.1.7.7 : N/A - This server uses $SSHtype $SSHver"

#Authentications Allowed - VanDyke VShell Only
echo " "
echo "CNL_SSH.1.7.8 : N/A - This server uses $SSHtype $SSHver"

#AuthPubkey - RemotelyAnywhere Only
echo " "
echo "CNL_SSH.1.7.9 : N/A - This server uses $SSHtype $SSHver"

#Bitvise WinSSHD Only
echo ""
echo "CNL_SSH.1.7.10 - N/A - This server uses $SSHtype"

#Attachmate Windows only
echo ""
echo "CNL_SSH.1.7.11 - This server uses $SSHtype"

echo " "
Z=1
for file in bin/openssl bin/scp bin/scp2 bin/sftp bin/sftp2 bin/sftp-server bin/sftp-server2 \
bin/slogin bin/ssh bin/ssh2 bin/ssh-add bin/ssh-add2 bin/ssh-agent bin/ssh-agent2 \
bin/ssh-askpass bin/ssh-askpass2 bin/ssh-certenroll2 bin/ssh-chrootmgr bin/ssh-dummy-shell \
bin/ssh-keygen bin/ssh-keygen2 bin/ssh-keyscan bin/ssh-pam-client \
bin/ssh-probe bin/ssh-probe2 bin/ssh-pubkeymgr bin/ssh-signer bin/ssh-signer2 \
lib/libcrypto.a lib/libssh.a lib/libssl.a lib/libz.a \
lib-exec/openssh/sftp-server lib-exec/openssh/ssh-keysign \
lib-exec/openssh/ssh-askpass lib-exec/sftp-server lib-exec/ssh-keysign \
lib-exec/ssh-rand-helper \
libexec/openssh/sftp-server libexec/openssh/ssh-keysign \
libexec/openssh/ssh-askpass libexec/sftp-server libexec/ssh-keysign \
libexec/ssh-rand-helper \
sbin/sshd sbin/sshd2 sbin/sshd-check-conf lib/svc/method/sshd \
lib/ssh/sshd
do
if [ -f /usr/opt/freeware/$file ]; then
   echo "CNL_SSH.1.8.2.$Z : "`ls -al /usr/opt/freeware/$file`
   FOUND="/usr/opt/freeware"
elif [ -f /usr/$file ]; then
   echo "CNL_SSH.1.8.2.$Z : "`ls -al /usr/$file`
   FOUND="/usr"
elif [ -f /usr/local/$file ]; then
   echo "CNL_SSH.1.8.2.$Z : "`ls -al /usr/local/$file`
   FOUND="/usr/local"
elif [ -f /usr/local/ssl/$file ]; then
   echo "CNL_SSH.1.8.2.$Z : "`ls -al /usr/local/ssl/$file`
   FOUND="/usr/local/ssl"
elif [ -f /opt/freeware/$file ]; then
   echo "CNL_SSH.1.8.2.$Z : "`ls -al /opt/freeware/$file`
   FOUND="/opt/freeware"
elif [ -f /usr/openssh/$file ]; then
   echo "CNL_SSH.1.8.2.$Z : "`ls -al /usr/openssh/$file`
   FOUND="/usr/openssh"
elif [ -f /usr/ssh/$file ]; then
   echo "CNL_SSH.1.8.2.$Z : "`ls -al /usr/ssh/$file`
   FOUND="/usr/ssh"
elif [ -f /$file ]; then
   echo "CNL_SSH.1.8.2.$Z : "`ls -al /$file`
   FOUND="/"
else
   echo "CNL_SSH.1.8.2.$Z : N/A - The file $file was not found on this server"
   FOUND=0
fi

#OSR Groups and UserIDs.
#Difficult to determine what is a system user and group per iSeC V3.0
#Research shows these files are typically owned by root:root so this script
#will only check for that:
##
if [ $FOUND != 0 ]; then
   if [ -L $FOUND/$file ]; then
      FOUND=`dirname $FOUND/$file`
      LINK=`basename $FOUND/$file`
      file=`ls -ald $FOUND/$LINK | awk '{print $NF}'`
      echo "CNL_SSH.1.8.2.$Z : "`ls -al $FOUND/$LINK`
   fi
   FILEUSER=`ls -ald $FOUND/$file | awk '{print $3}'`
   FILEGROUP=`ls -ald $FOUND/$file | awk '{print $4}'`
   FILEPERM=`ls -ald $FOUND/$file | awk '{print $1}' | cut -c9`
#   echo $FILEUSER | egrep -f OSR_USERIDS > /dev/null 2>&1
#   if (($?)); then
   if [ $FILEUSER != "root" ]; then
#      echo "CNL_SSH.1.8.2.$Z : WARNING - The OSR $FOUND/$file is NOT assigned to an approved userID"
      echo "CNL_SSH.1.8.2.$Z : WARNING - The OSR $FOUND/$file is NOT owned by root."
   else
      echo "CNL_SSH.1.8.2.$Z : The $FOUND/$file OSR is assigned to an approved userID"
   fi
#   echo $FILEGROUP | egrep -f OSR_GROUPS > /dev/null 2>&1
#   if (($?)); then
   if [ $FILEGROUP != "root" ]; then
      echo "CNL_SSH.1.8.2.$Z : WARNING - The OSR $FOUND/$file is not assigned to group root."
#      echo "CNL_SSH.1.8.2.$Z : WARNING - The OSR $FOUND/$file is NOT assigned to an approved groupID"
   else
      echo "CNL_SSH.1.8.2.$Z : The $FOUND/$file OSR is assigned to an approved groupID"
   fi
   if [ $FILEPERM = "w" ]; then
      echo "CNL_SSH.1.8.2.$Z : WARNING - The OSR $FOUND/$file has permissions set on other that is NOT r-x or more restrictive!"
   else
      echo "CNL_SSH.1.8.2.$Z : The OSR $FOUND/$file has permissions set on other that are r-x or more restrictive."
   fi
fi
((Z+=1))
echo " "
done

Z=1
for file in /etc/openssh/sshd_config /etc/ssh/sshd_config \
/etc/ssh/sshd2_config /etc/ssh2/sshd_config \
/etc/ssh2/sshd2_config /etc/sshd_config /etc/sshd2_config \
/usr/local/etc/sshd_config /usr/local/etc/sshd2_config \
/usr/lib/ssh/ssh-keysign
do
if [ -f $file ]; then
   echo "CNL_SSH.1.8.3.$Z : "`ls -al $file`
##
#Difficult to determine what is a system user and group per iSeC V3.0
#Research shows these files are typically owned by root:root so this script
#will only check for that:
##
   FILEUSER=`ls -ald $file | awk '{print $3}'`
   FILEGROUP=`ls -ald $file | awk '{print $4}'`
   FILEPERM=`ls -ald $file | awk '{print $1}' | cut -c9`
#   echo $FILEUSER | egrep -f OSR_USERIDS > /dev/null 2>&1
#   if (($?)); then
   if [ $FILEUSER != "root" ]; then
#      echo "CNL_SSH.1.8.3.$Z : WARNING - The OSR $file is NOT assigned to an approved userID"
      echo "CNL_SSH.1.8.3.$Z : WARNING - The OSR $file is NOT owned by root."
   else
      echo "CNL_SSH.1.8.3.$Z : The $file OSR is assigned to an approved userID"
   fi
#   echo $FILEGROUP | egrep -f OSR_GROUPS > /dev/null 2>&1
#   if (($?)); then
   if [ $FILEGROUP != "root" ]; then
#      echo "CNL_SSH.1.8.3.$Z : WARNING - The OSR $file is NOT assigned to an approved groupID"
      echo "CNL_SSH.1.8.3.$Z : WARNING - The OSR $file is not assigned to group root."
   else
      echo "CNL_SSH.1.8.3.$Z : The $file OSR is assigned to an approved groupID"
   fi
   if [ $FILEPERM = "w" ]; then
      echo "CNL_SSH.1.8.3.$Z : WARNING - The OSR $file has permissions set on other that is NOT r-x or more restrictive!"
   else
      echo "CNL_SSH.1.8.3.$Z : The OSR $file has permissions set on other that are r-x or more restrictive."
   fi
else
   echo "CNL_SSH.1.8.3.$Z : N/A - The file $file was not found on this server"
fi
((Z+=1))
echo " "
done

echo " "
Z=1
until [ $Z -eq 8 ]
do
echo "CNL_SSH.1.8.4.$Z : N/A - This is a Linux server"
echo ""
((Z+=1))
done

echo " "
Z=1
until [ $Z -eq 15 ]
do
if [ $Z -ne 9 ]; then
   echo "CNL_SSH.1.8.5.$Z : N/A - This is a Linux server"
   echo ""
fi
((Z+=1))
done

echo " 	"
if ((!$OpenSSHInstalled)); then
   SSHverCompare=`echo "if ( $BaseSSHver >= 3.5) 1" | bc`
   if [[ -z $SSHverCompare ]]; then
           SSHverCompare=0
   fi
   if (($SSHverCompare)); then
      echo "CNL_SSH.1.9.1 : Checking PermitUserEnvironment from $SSHD"
      echo "CNL_SSH.1.9.1 : This line should be #ed out or set to no"
      VAL=PermitUserEnvironment
      VAL2=no
      Should_Comment;
   else
      echo "CNL_SSH.1.9.1 : N/A - This server uses $SSHtype $SSHver"
   fi
elif ((!$SunSSHInstalled)); then
   SSHverCompare=`echo "if ( $BaseSSHver >= 1.2) 1" | bc`
   if [[ -z $SSHverCompare ]]; then
           SSHverCompare=0
   fi
   if (($SSHverCompare)); then
      echo "CNL_SSH.1.9.1 : Checking PermitUserEnvironment from $SSHD"
      echo "CNL_SSH.1.9.1 : This line should be #ed out OR set to no"
      VAL=PermitUserEnvironment
      VAL2=no
      Should_Comment;
   else
      echo "CNL_SSH.1.9.1 : N/A - This server uses $SSHtype $SSHver"
   fi
else
   echo "CNL_SSH.1.9.1 : N/A - This server uses $SSHtype $SSHver"
fi

echo " "
echo "CNL_SSH.1.9.2 : Checking StrictModes from $SSHD"
echo "This line should be #ed out or set to yes"
VAL=StrictModes
VAL2=yes
Should_Comment;

SSHverCompare=`echo "if ( $BaseSSHver >= 3.9) 1" | bc`
if [[ -z $SSHverCompare ]]; then
        SSHverCompare=0
fi
if (( $OpenSSHInstalled==0 && $SSHverCompare==1 )); then
   echo ""
   cat /dev/null > CNL_SSH193_temp
   echo "CNL_SSH.1.9.3 : Checking AcceptEnv from $SSHD"
#   echo "CNL_SSH.1.9.3 : Parameter MUST NOT EXIST in sshd_config"
   /bin/grep "^AcceptEnv" $SSHD > /dev/null 2>&1
   if ((!$?)); then
      /bin/grep "^AcceptEnv" $SSHD | egrep -w 'TERM|PATH|HOME|MAIL|SHELL|LOGNAME|USER|USERNAME|LIBPATH|SHLIB_PATH' > /dev/null 2>&1
      if ((!$?)); then
         /bin/grep "^AcceptEnv" $SSHD | egrep -w 'TERM|PATH|HOME|MAIL|SHELL|LOGNAME|USER|USERNAME|LIBPATH|SHLIB_PATH' >> CNL_SSH193_temp
      fi
      /bin/grep "^AcceptEnv" $SSHD | grep -w '[a-Z]*[a-Z]_RLD' > /dev/null 2>&1
      if ((!$?)); then
         /bin/grep "^AcceptEnv" $SSHD | grep -w '[a-Z]*[a-Z]_RLD' >> CNL_SSH193_temp
      fi
      grep "^AcceptEnv" $SSHD | egrep -w 'DYLD_[a-Z]*[a-Z]|LD_[a-Z]*[a-Z]|LDR_[a-Z]*[a-Z]' > /dev/null 2>&1
      if ((!$?)); then
         grep "^AcceptEnv" $SSHD | egrep -w 'DYLD_[a-Z]*[a-Z]|LD_[a-Z]*[a-Z]|LDR_[a-Z]*[a-Z]' >> CNL_SSH193_temp
      fi
      if [ -s CNL_SSH193_temp ]; then
         echo "CNL_SSH.1.9.3 : WARNING - An illegal variable has been found associated with the AcceptEnv parameter in $SSHD."
         cat CNL_SSH193_temp >> $LOGFILE
      else
         echo "CNL_SSH.1.9.3 : The AcceptEnv parameter was found in $SSHD, but no illegal variables were associated with it:"
         /bin/grep "^AcceptEnv" $SSHD >> $LOGFILE
      fi
#     echo `/bin/grep -i AcceptEnv $SSHD`
#   	echo "CNL_SSH.1.9.3 : WARNING - This parameter should be removed from $SSHD"
   else
   	echo "CNL_SSH.1.9.3 : The AcceptEnv parameter was not found in $SSHD"
   fi
   rm -rf CNL_SSH193_temp
else
   echo "CNL_SSH.1.9.3 : N/A - This server uses $SSHtype $SSHver"
fi

echo " 	" 
echo "CNL_SSH.2.0.1.1 : Checking PrintMotd from $SSHD"
echo "CNL_SSH.2.0.1.1 : This line should be #ed out OR set to yes"
VAL=PrintMotd
VAL2=yes
Should_Comment;

echo " "
echo "CNL_SSH.2.0.1.2 : N/A - This server uses $SSHtype $SSHver"

#VanDyke Only
echo ""
echo "CNL_SSH.2.0.1.3 - N/A - This server uses $SSHtype"

#Attachmate Windows Only
echo ""
echo "CNL_SSH.2.0.1.4 - N/A - This server uses $SSHtype"

echo " "
grep "^Protocol" $SSHD  > /dev/null 2>&1
if ((!$?)); then
   TEST=`grep "^Protocol" $SSHD | awk '{print $2}'`
   echo $TEST | grep "1" > /dev/null 2>&1
   if ((!$?)); then
      echo `grep "^Protocol" $SSHD`
      echo "CNL_SSH.2.1.1.1 : WARNING - Protocol 1 is enabled in $SSHD"
      echo "CNL_SSH.2.1.1.1 : THIS SCRIPT CANNOT CHECK THE BIT LENGTH FOR PUBLIC KEYS!"
   else
      echo "CNL_SSH.2.1.1.1 : N/A - Protocol 1 is not enabled in $SSHD"
   fi
else
   echo "CNL_SSH.2.1.1.1 : N/A - Protocol 1 is not enabled in $SSHD"
fi

echo " "
echo "CNL_SSH.2.1.1.2 : Data Transmissions - All native encryption ciphers...."
echo "CNL_SSH.2.1.1.2 : THIS SCRIPT CANNOT CHECK THIS SECTION!"

echo " "
echo "CNL_SSH.2.1.1.3 : Data Transmissions - DES algorithm...."
echo "CNL_SSH.2.1.1.3 : THIS SCRIPT CANNOT CHECK THIS SECTION!"

echo " "
echo "CNL_SSH.2.1.1.4 : Data Transmission - Server host keys...."
echo "CNL_SSH.2.1.1.4 : THIS SCRIPT CANNOT CHECK THIS SECTION!"

#Bitvise WinSSHD Only
echo ""
echo "CNL_SSH.2.1.1.5 - N/A - This server uses $SSHtype"

#Attachmate Windows Only
echo ""
echo "CNL_SSH.2.1.1.6 - N/A - This server uses $SSHtype"

#Attachmate Windows Only
echo ""
echo "CNL_SSH.2.1.1.7 - N/A - This server uses $SSHtype"

echo " "
#echo "CNL_SSH.2.2.1.1 : Private Key Passphrases must be assigned to all private keys used...."
#echo "CNL_SSH.2.2.1.1 : THIS SCRIPT CANNOT CHECK THIS SECTION!"
cat /dev/null > CNL_SSH2211
CHECK=1
for FILE in `find /home -type f  -name "id_[dr]sa*" -print   2>/dev/null | grep -v .pub`
do
if [ -f $FILE ]; then
   CHECK=0
fi
grep  "ENCRYPTED" $FILE > /dev/null 2>&1
if (($?)); then
   echo "NOT using Pass Phrase:	$FILE" >> CNL_SSH2211
fi
done
if ((!$CHECK)); then
   if [ -s CNL_SSH2211 ]; then
      echo "CNL_SSH.2.2.1.1 : WARNING - Private ssh keyfiles exist without encryption set:"
      cat CNL_SSH2211 >> $LOGFILE
   else
      echo "CNL_SSH.2.2.1.1 : All private ssh keyfiles have a passphrase set."
   fi
else
   echo "CNL_SSH.2.2.1.1 : No private ssh keyfiles were found on the server."
fi
rm CNL_SSH2211

echo " "
if ((!$CHECK)); then
   echo "CNL_SSH.2.2.1.2 : Private Key Passphrase - must have minimum number of 5 words each...."
   echo "CNL_SSH.2.2.1.2 : THIS SCRIPT CANNOT CHECK THIS SECTION AS THE PASSHPHRASES ARE ENCRYPTED!"
else
   echo "CNL_SSH.2.2.1.2 : No private ssh keyfiles were found on the server."
fi

echo " "
if ((!$CHECK)); then
   echo "CNL_SSH.2.2.1.3 : Private Key Passphrase - system to system authentication...."
   echo "CNL_SSH.2.2.1.3 : THIS SCRIPT CANNOT CHECK THIS SECTION! WE HCNL_SSHE NO WAY OF CHECKING THE SERVER(S) THIS USER HAS ACCESS TO TO VERIFY THE AUTHORIZED_KEYS FILE!!"
else
   echo "CNL_SSH.2.2.1.3 : No private ssh keyfiles were found on the server."
fi

echo " "
cat /dev/null > CNL_SSH2214
CHECK=1
for FILE in `find /home -type f \( -name "authorized_keys" -o -name "authorized_keys2" \) -print  2>/dev/null`
do
if [ -f $FILE ]; then
   CHECK=0
fi
if [ -s $FILE ]; then
   grep "^from=" $FILE > /dev/null 2>&1
   if (($?)); then
      echo $FILE >> CNL_SSH2214
   fi
fi
done
if ((!$CHECK)); then
   if [ -s CNL_SSH2214 ]; then
      echo "CNL_SSH.2.2.1.4 : WARNING - authorized_keys[2] file(s) exist which do not contain the 'from=' option."
      echo "CNL_SSH.2.2.1.4 : This script is unable to deterimine which users are security administration or systems authority rights."
      echo "CNL_SSH.2.2.1.4 : Here is a list of the file(s) found:"
      cat CNL_SSH2214 >> $LOGFILE
   else
      echo "CNL_SSH.2.2.1.4 : All authorized_keys and/or authorized_keys2 file(s) contain the 'from=' option in them."
   fi
else
   echo "CNL_SSH.2.2.1.4 : No authorized_keys nor authorized_keys2 files were found on the server."
fi
rm CNL_SSH2214

echo " "
id sshd > /dev/null 2>&1
if ((!$?)); then
   echo "CNL_SSH.5.0.1 : Here is a list of group(s) that the sshd ID belongs to:"
   /usr/bin/groups sshd | awk -F':' '{print $2}' >> $LOGFILE
else
   echo "CNL_SSH.5.0.1 : WARNING - The user ID sshd does NOT exist!"
fi

##
#This section is for HIPAA Accounts only!!!
##
if (($HIPAA_Check)); then
# if ((!$HIPAA_Check)); then
   echo ""
   ShowLogList=1
   if [ -f /etc/cron.daily/logrotate ]; then
      if [ -f /etc/logrotate.conf ]; then
         grep "^rotate" /etc/logrotate.conf > /dev/null 2>&1
         if ((!$?)); then
            RotateDays=`grep "^rotate" /etc/logrotate.conf | awk '{print $2}' | head -1`
            if [ $RotateDays -lt 39 ]; then
               echo "CNL_SSH.10.1.1.2 : WARNING - The system is NOT keeping 270 days worth of log files. It is only keeping $RotateDays week(s) of log files."
            else
               echo "CNL_SSH.10.1.1.2 : The system is keeping at least 270 days worth of log files."
               grep "^rotate" /etc/logrotate.conf | head -1 >> $LOGFILE
            fi
         else
            echo "CNL_SSH.10.1.1.2 : WARNING - The rotate paramter is not set in /etc/logrotate.conf!"
            ShowLogList=0
         fi
      else
         echo "CNL_SSH.10.1.1.2 : WARNING - The /etc/logrotate.conf file does not exist!"
         ShowLogList=0
      fi
   else
      echo "CNL_SSH.10.1.1.2 : WARNING - The /etc/cron.daily/logrotate file does not exist!"
      ShowLogList=0
   fi
   if ((!$ShowLogList)); then
      echo "CNL_SSH.10.1.1.2 : Here is a long listing of the system log files. Ensure there are at least 270 days worth:"
      for file in messages secure wtmp faillog
      do
      ls -al /var/log/$file | awk '{print $9,"==== "$6,$7,$8}' >> $LOGFILE
      done
   fi
fi
   


#If the sshd_config file was not found then we skipped the ssh checks and moved on to sudo checks
fi
rm -rf $LOGFILE

