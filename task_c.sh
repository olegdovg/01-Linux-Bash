#!/bin/bash

# Вхідні дані
SOURCE_DIR="$HOME/source/"
DEST_DIR="$HOME/desination/"
TMP_FILE=$1
#/tmp/copyfileslist.txt
TMP_FILE1=$2
#/tmp/existfileslist.txt
LOG=/tmp/Loglist.txt
### Перевірка наявності каталогу з даними


if [ -d "${SOURCE_DIR}" ]; then
echo "Source directory found"
else
echo "Source directory not found. Please check above variables are set correctly"
echo "script exited"
exit 1
fi

### Перевірка наявності каталогу призначення
### Якщо немає то створить
### Якщо не створить то вийде і повідомить про помилку

if [ -d "${DEST_DIR}" ]; then
echo "Destination directory found, all ok"
else
echo "Destination directory not found, creating now"
mkdir -p "${DEST_DIR}"
if [ $? -eq 0 ]; then
echo "Successfully created destination directory."
else
echo "Failed to create destination directory. Script exited"
exit 1
fi
fi

echo " "
echo "==================================================="
echo " "

### Видалення зайвих файлів з каталогу призначення
###
 
cd "${DEST_DIR}"
#nos=""
if [ $? -eq 0 ]; then
find . -type f > ${TMP_FILE1}
while read CURRENT_FILE_NAME
do
echo "Check availability ${CURRENT_FILE_NAME:2} в ${SOURCE_DIR}"
nos=$(find ${SOURCE_DIR}${CURRENT_FILE_NAME:2} -type f )
length=$(expr length "$nos")

if [ $length -eq 0 ]; then
#echo "$nos"
echo "File ${CURRENT_FILE_NAME:2} be deleted from .${DEST_DIR} ---> `date +%Y-%m-%d-%H-%M`" >> ${LOG}

rm "${DEST_DIR}${CURRENT_FILE_NAME:2}"
fi
#echo " "

done < ${TMP_FILE1}
rm -f ${TMP_FILE1}
fi

echo " "
echo "==================================================="
echo " "

### Копіювання файлів з каталогу призначення
### 

cd "${SOURCE_DIR}"

if [ $? -eq 0 ]; then
find . -type f > ${TMP_FILE}

while read CURRENT_FILE_NAME
do

echo "Check availability ${CURRENT_FILE_NAME:2} в ${DEST_DIR}"
nos=$(find ${DEST_DIR}${CURRENT_FILE_NAME:2} -type f )
length=$(expr length "$nos")

if [ $length -eq 0 ]; then
#echo "$nos"
echo "File ${CURRENT_FILE_NAME:2} be be added from .${SOURCE_DIR} as NEW ---> `date +%Y-%m-%d-%H-%M`" >> ${LOG}

fi

cp --parents "${CURRENT_FILE_NAME}" "${DEST_DIR}"
if [ $? -eq 0 ]; then
echo "File ${CURRENT_FILE_NAME:2} successfully copied to .${DEST_DIR}"
#rm -f "${CURRENT_FILE_NAME}"
else
echo "File ${CURRENT_FILE_NAME} failed to copy"
fi
done < ${TMP_FILE}
rm -f ${TMP_FILE}
fi


