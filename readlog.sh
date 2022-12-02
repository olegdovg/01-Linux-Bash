#!/bin/bash
LOG_FILE="$1"


function request_per_day() {
    declare -A day_array
    while read line; do
        day=$(echo "$line" | sed 's/.*\[//g;s/].*//g;s/:.*//g')
        if [[ -v day_array[$day] ]]; then
           day_array[$day]=$((day_array[$day]+1))
        else
            day_array[$day]=1
        fi
    done < $LOG_FILE

    for day in ${!day_array[@]}; do echo ${day_array[$day]} $day; done | sort -rn | head -1
}

function request_per_ip() {
    declare -A ip_array
    while read line; do
        ip=$(echo $line | awk '{print $1}')
        if [[ -v ip_array[$ip] ]]; then
            ip_array[$ip]=$((ip_array[$ip]+1))
        else
            ip_array[$ip]=1
        fi
    done < $LOG_FILE

    for ip in ${!ip_array[@]}; do echo ${ip_array[$ip]} $ip; done | sort -rn | head -1
}




echo "1. From which ip were the most requests?"
 request_per_ip
echo ""
 cat $1 | awk '{print \$1}' | uniq -c | sort -rn | head -1
echo ""
echo "2. What is the most requested page?"
 cat $1 |awk '($9 ~ /200/)' | awk '{print $9,$7}' | uniq -c | sort -rn | head -1
echo ""
echo "3. How many requests were there from each ip?"
 request_per_day
echo ""
echo "4. What non-existent pages were clients referred to?"
 cat $1 |awk '($9 ~ /403/)' | awk '{print $9,$7}' | uniq -c | sort -rn | head -1
echo ""
echo "5. What time did site get the most requests?"
 request_per_time
echo ""
echo "6. What search bots have accessed the site? (UA + IP)"

