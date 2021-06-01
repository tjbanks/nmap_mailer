#!/bin/sh
# 0 12 * * * /root/nmap_scans/nmap_mail_script.sh
alias wanip='dig @resolver1.opendns.com ANY myip.opendns.com +short'
MAILTO="nmap@changeme.com"
MAILFROM="nmap@changeme.com"
SENDER="https://github.com/tjbanks/nmap_mailer"
WANIP=`wanip`
LOCALIP=`hostname -I | cut -d\  -f2-`
HOST=`hostname`
TARGETS="127.0.0.1/32"
#Fast minimal
OPTIONS="-v -T4 -F -sV"
SCAN_FOLDER=/root/nmap_scans/scans
INTERFACE=ens192
#Slow comprehensive scan
#OPTIONS="-sS -sU -T4 -A -v -PE -PP -PS80,443 -PA3389 -PU40125 -PY -g 53 –script \"default or (discovery and safe)\""
#TCP,UDP,OS detect
#OPTIONS="-v -T4 -sV -A -sT -sU -p1-65535"
date=`date +%F`
emailfile="email.txt"
filename=`basename "$0"`
alias writemail="sed 's|^|<br />|' >> $emailfile"
alias escapehtml="sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/\"/\&quot;/g; s/'\"'\"'/\&#39;/g'"
scriptlocation=`pwd`

cd $SCAN_FOLDER
echo "<html><body>" > $emailfile
echo "Dear security team member," | writemail
echo "" | writemail
echo "An Nmap scan was initiated `date` for the following targets:" | writemail
echo "<strong>$TARGETS</strong>" | sed 's/\s\+/\n/g' | writemail
echo "" | writemail
echo $SENDER | writemail
echo "" | writemail

echo "<h3>SCANNER INFO</h3>" >> $emailfile
echo "Nmap Scanner Host: $HOST" | writemail
#echo "Script location: $scriptlocation/`basename "$0"`" | writemail
echo "Crontab: `crontab -l | grep $filename`" | writemail
echo "Script last updated: 6/1/2021" | writemail
echo "Local IP: $LOCALIP" | writemail
echo "External IP: $WANIP" | writemail
echo "" | writemail

nmap -e $INTERFACE $OPTIONS $TARGETS -oA scan-$date > last_run_log.txt
if [ -e scan-prev.xml ]; then
        ndiff scan-prev.xml scan-$date.xml > diff-$date
        echo "<h3>DIFFERENCES SINCE LAST SCAN</h3>" >> $emailfile
        cat diff-$date | writemail
        echo "\n" | writemail
fi
echo "<h3>COMPLETE SCAN OUTPUT</h3>" >> $emailfile
echo "" | writemail

cat scan-$date.nmap | escapehtml | writemail
echo "" | writemail
echo "*** END OF REPORT ***" | writemail
echo "</body></html>" | writemail

ln -sf scan-$date.xml scan-prev.xml

#cat $emailfile
mail -a 'Content-Type: text/html' -s "Nmap Report - $date" -a FROM:$MAILFROM $MAILTO < $emailfile
