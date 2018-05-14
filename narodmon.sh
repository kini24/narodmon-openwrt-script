#!/bin/sh

# Необходимые для работы пакеты: owserver, owshell, bc, curl

# Автоматическое получение MAC-адреса устройства
#DEVICE_MAC=$(ifconfig -a | grep HWaddr | awk '{print $5}' | sed 's/://g')

# Общие настройки
DATAFILE="/tmp/narodmon"
LOGFILE="/mnt/sda3/log/narodmon.log"
TEMPFILE="$DATAFILE.tmp"
LAT=55.994814
LNG=93.029621
ELE=175

# Настройки для narodmon.ru
SERVER='narodmon.ru'
PORT='8283'
DEVICE_NAME='DIR-825'
DEVICE_MAC='****'
SENSOR_ID='****'
SENSOR_DESC='Температура на улице'

# Параметры отправки сообщения
BotToken="****"
URL="https://api.telegram.org/bot$BotToken/sendMessage"
ChatID=****

# Снимаем показания и формируем временный файл
echo "#$DEVICE_MAC#$DEVICE_NAME#$LAT#$LNG#$ELE" >> $DATAFILE
TIME=$(date -I"seconds")
CELSIUS=$(/usr/bin/owread -s 192.168.1.1:4304 ****/temperature | sed 's/^[ \t]*//')
echo "#$SENSOR_ID#$CELSIUS#$TIME#$SENSOR_DESC" >> $DATAFILE

# Перед отправкой проверяем:
# 1) В файле скопилось не слишком много данных для отправки;
# 2) в файле нет повторяющихся строк, иначе убираем дубликаты;
# 3) передаем не пустой файл

# Если скопилось много данных в буфере, сначала отправляем их
# Подсчитываем количество строк с начала файла и до первой строки с ##
DELAYED_LC=$(sed '1,/##/!g; /^$/d $DATAFILE' | wc -l)
COUNTER=$($DELAYED_LC - 1 | bc)

if [ $COUNTER -gt 15 ]
  then
    head -n 15 $DATAFILE > $TEMPFILE
    echo "##" >> $TEMPFILE

    echo $(date) >> $LOGFILE
    echo "Отправка не доставленных ранее данных." >> $LOGFILE
    RESULT=$(cat $TEMPFILE | nc $SERVER $PORT)

    echo -e "$RESULT\n" >> $LOGFILE

    if [ "$RESULT" == "OK" ]
      then
        sed -i '2,15d' $DATAFILE
        break
    fi

    exit 1
fi

# Если неотправленных данных нет, то отправляем текущие
LINECOUNT=$(cat $DATAFILE | wc -l)

if [ $LINECOUNT -ge 2 ]
  then
    echo $(date) >> $LOGFILE
    echo "$(sed '/##/d' $DATAFILE | awk '!($0 in a) {a[$0];print}')" > $DATAFILE
    echo "##" >> $DATAFILE
    cat $DATAFILE >> $LOGFILE

    for i in 1 2 3 4 5
      do
        RESULT=$(cat $DATAFILE | nc $SERVER $PORT)
        echo -e "$RESULT\n" >> $LOGFILE
        if [ "$RESULT" == "OK" ]
          then
            cp /dev/null $DATAFILE
            exit 1
          elif [ "$RESULT" == "ERROR NO CHANGES" ] || [ "$RESULT" == "429 Too Many Requests" ]
            then
              cp /dev/null $DATAFILE
              exit 1
          else
            MSG="Сервер $SERVER сообщил об ошибке: $RESULT"
            curl -s $URL -d chat_id=$ChatID -d text="$MSG"
        fi
        sleep 5
    done
fi
