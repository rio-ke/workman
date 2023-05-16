GOODBAD=1
if [[ -s /etc/issue ]] && [[ ! -z `grep -v "^#" /etc/issue` ]]; then
   echo "AD.2.0.1 : The /etc/issue file exists and contains active entries."
   cat /etc/issue 
   GOODBAD=0
fi
if [[ -s /etc/motd ]] && [[ ! -z `grep -v "^#" /etc/motd` ]]; then
   echo "AD.2.0.1 : The /etc/motd file exists and contains active entries."
   cat /etc/motd
   GOODBAD=0
fi
if (($GOODBAD)); then
   echo "AD.2.0.1 : WARNING - Both the /etc/issue and the /etc/motd files either do not exist or neither contain any active entries!"
fi

