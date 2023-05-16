GOODBAD=1
rpm -qa | grep -q "openssl"
if ((!$?)); then
   echo "AD.2.1.2 : openssl is installed on this server."
   which openssl > /dev/null 2>&1
   if ((!$?)); then
      which openssl
   fi
   GOODBAD=0
fi
gpg --version > /dev/null 2>&1
if ((!$?)); then
   echo "AD.2.1.2 : GPG is installed on this server."
   gpg --version | head -1
   GOODBAD=0
fi
if (($GOODBAD)); then
   echo "AD.2.1.2 : WARNING - Neither openssl nor GPG appear to be installed on this server!"
fi

