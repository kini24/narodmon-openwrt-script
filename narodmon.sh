#!/bin/sh

# Автоматическое получение MAC-адреса устройства
#DEVICE_MAC=$(ifconfig -a | grep HWaddr | awk '{print $5}' | sed 's/://g')


# Общие настройки
LAT=55.994814
LNG=93.029621
ELE=175

DATA_PATH='**.************/temperature'
LOG_FILE='/mnt/usb-hdd/log/narodmon.log'
TEMP_FILE='/tmp/narodmon'

# Настройки для narodmon.ru
DEVICE_NAME='DIR-825'
DEVICE_MAC='************'
SENSOR_ID='****************'

#===============================================================================

# Снимаем показания и формируем временный файл
echo "#$DEVICE_MAC#$DEVICE_NAME#$LAT#$LNG#$ELE" >> $TEMP_FILE
CELSIUS=$(/usr/bin/owread -s 192.168.1.1:4304 $DATA_PATH | sed 's/^[ \t]*//')
FAHRENHEIT=$(/usr/bin/owread -F -s 192.168.1.1:4304 $DATA_PATH | sed 's/[ \s]//g')
TIME=$(date -I"seconds")
echo "#$SENSOR_ID#$CELSIUS#$TIME#Температура на улице" >> $TEMP_FILE

#===============================================================================

# Передача данных на Narodmon.ru
# В случае успеха сервер отвечает "ОК", иначе возвращает текст ошибки

# Перед отправкой проверяем:
# 1) в файле нет повторяющихся строк, иначе убираем дубликаты;
# 2) что передаем не пустой файл
LC=`cat /tmp/narodmon | wc -l`
if [ $LC -ge 2 ]
  then
    echo "$(sed '/##/d' /tmp/narodmon | awk '!($0 in a) {a[$0];print}')" > $TEMP_FILE
    echo "##" >> #TEMP_FILE
    cat /tmp/narodmon >> $LOG_FILE
    for i in 1 2 3 4 5
      do
        RESULT=$(cat /tmp/narodmon | nc narodmon.ru 8283)
        echo -e "$RESULT\n" >> $LOG_FILE
        if [ "$RESULT" == "OK" ]
          then
            cp /dev/null $TEMP_FILE
            break
        fi
        sleep 5
    done
fi
