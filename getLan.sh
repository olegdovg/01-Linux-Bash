#!/bin/bash

# Масив з двійковими значеннями 00000000, 00000001, ... 11111111
BARRAY=({0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1} })

# Змінна PARAMS містить "192.168.1.10 255.255.255.0"
PARAMS=$(ifconfig enp0s3 | grep netmask | awk '{print $2" "$4}')

# IP_ADDRESS містить "192.168.1.10"
IP_ADDRESS=${PARAMS%% *}
# Замінюємо крапки на прогалини
IP_ADDRESS=${IP_ADDRESS//./ }

# Перетворюємо октети IP-адреси на бінарний вигляд
BINARY_IP_ADDRESS=$(for octet in $IP_ADDRESS; do echo -n ${BARRAY[octet]}" "; done)

# Поділяємо побітово і поміщаємо в масив
BIN_IP_SEP1=${BINARY_IP_ADDRESS//1/1 }
BINARY_IP_ARRAY=( ${BIN_IP_SEP1//0/0 } )

# Маска підмережі (255.255.255.0)
NETMASK=${PARAMS#* }
# Замінюємо крапки на прогалини
NETMASK=${NETMASK//./ }

# Перетворюємо маску підмережі на бінарний вигляд
BINARY_NETMASK=$(for octet in $NETMASK; do echo -n ${BARRAY[octet]}" "; done)
echo "$BINARY_NETMASK"

# Поділяємо маску підмережі побітово і поміщаємо в масив
BIN_MASK_SEP1=${BINARY_NETMASK//1/1 }
BINARY_MASK_ARRAY=( ${BIN_MASK_SEP1//0/0 } )

# Рахуємо кількість бітів, встановлених в 1
BITS_COUNT=0
for i in ${BINARY_MASK_ARRAY[@]}
do

    if [ $i -eq 1 ]
    then
    BITS_COUNT=$((BITS_COUNT + 1))
    fi
done

# Рахуємо адресу підмережі
NEW_ADDRESS=""
for i in {0..31}
do
    # Після кожних 8 біт ставимо пробіл
    [ $(($i % 8)) -ne 0 ] || NEW_ADDRESS+=" "
    if [ "${BINARY_MASK_ARRAY[$i]}" == "1" ]
    then
        # Якщо біт у масці підмережі дорівнює 1, додаємо біт з адреси
        NEW_ADDRESS+="${BINARY_IP_ARRAY[$i]}"
    else
        # Якщо біт у масці підмережі дорівнює 0, додаємо його
        NEW_ADDRESS+="${BINARY_MASK_ARRAY[$i]}"
    fi
done

# Конвертуємо значення октетів у десяткові значення
DECIMAL_ADDRESS=`echo $(for octet in $NEW_ADDRESS; do echo $((2#$octet)); done)`
# Замінюємо прогалини на крапки
DECIMAL_ADDRESS=${DECIMAL_ADDRESS// /.}

# Виводимо підсумковий результат
echo $DECIMAL_ADDRESS/$BITS_COUNT