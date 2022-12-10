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

function request_per_time() {
    declare -A time_array
    while read line; do
        time=$(echo $line | awk '{print $4}'| cut -c 14-21)
        if [[ -v time_array[$time] ]]; then
            time_array[$time]=$((time_array[$time]+1))
        else
            time_array[$time]=1
        fi
    done < $LOG_FILE

    for time in ${!time_array[@]}; do echo ${time_array[$time]} $time; done | sort -rn | head -1
}

function request_per_bot() {

    while read line; do
        bot_ip="$(echo $line | awk '{print $1}') - $(echo $line | cut -d\" -f6)"
        echo "$bot_ip" >> 1.log
    done < $LOG_FILE

    
    cat 1.log | grep bot | sort | uniq 
    rm -f 1.log
}

echo "1. From which ip were the most requests?"
 request_per_ip
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
request_per_bot