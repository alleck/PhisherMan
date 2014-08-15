exiqgrep -i > /var/log/phishedsites.log

while read line
do

check1=$(exim -Mvb $line | grep -i -E "E-ZPass|PayPal|USPS|firstbanknigeria|1stbanknigeria-online|chasebankonline|Yahoo Password|Hotmail Password|Google Password|capitalone|zenithbank|National Westminster|Royal Bank|Santander Online Banking")

if [[ -n $check1 ]]
then
exim -Mf "$line" > /var/log/phishedsitesjob.log
fi

done < /var/log/phishedsites.log

cat /var/log/phishedsitesjob.log | awk '{print $4}' > /var/log/phishedsitessort.log

while read $this
do
if [[ $this != "already" ]]
then
check2="found"
fi
done < /var/log/phishedsitessort.log

if [[ -n $check2 ]]
then
echo "Phishies were found on $(hostname)! The messages have been frozen in the queue" | mail -s "Phishies found on $(hostname)!" support@hostek.com
fi

rm -f /var/log/phishedsitessort.log
