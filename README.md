# narodmon-openwrt-script
<b>Скрипт отправки данных на сервер narodmon</b><br/>
<br/>
Оборудование: D-Link DIR-825<br/>
Прошивка: OpenWrt Chaos Calmer 15.05.1<br/>
Необходимые пакеты: owserver, owshell<br/>
<br/>
Скрипт собирает данные с подключенных датчиков, формирует пакет для отправки и затем отправляет его. Делается 5 попыток отправки данных, после чего скрипт завершается для следующего вызова. Если в результате одной из попыток сервер подтвердил прием данных, скрипт завершает свою работу. В случае, если ни одна попытка не завершилась удачно, данные накапливаются во временном файле до момента пока сервер не ответит "ОК". После того, как скрипт получает потверждение об успешном приеме пакета, содержимое временного файла стирается.<br/>
В ходе работы делается форматирование данных для приведения к корректному виду (удаление лишних символов), удаляются дублирующиеся строки (например, данные об устройстве передачи). Непосредственно перед передачей пакета данных в файл добавляются закрывающие "##".<br/>
Если вам требуется использовать время UTC, то нужно в строку 27 добавить ключ -u. Тогда команда получения текущего времени будет выглядеть следующим образом:<br/>
<i>TIME=$(date -uI"seconds")</i><br/>
<br/>
Пример журнала работы скрипта:<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\#Сервер\#55.994814\#93.029621\#175<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\#26.625\#2017-06-16T16:05:01+0700\#Температура на улице<br/>
\#\#<br/>
OK<br/>
<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\#Сервер\#55.994814\#93.029621\#175<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\#26.75\#2017-06-16T16:10:01+0700\#Температура на улице<br/>
\#\#<br/>
<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\#Сервер\#55.994814\#93.029621\#175<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\#26.75\#2017-06-16T16:10:01+0700\#Температура на улице<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\#26.6875\#2017-06-16T16:15:01+0700\#Температура на улице<br/>
\#\#<br/>
<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\#Сервер\#55.994814\#93.029621\#175<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\#26.75\#2017-06-16T16:10:01+0700\#Температура на улице<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\#26.6875\#2017-06-16T16:15:01+0700\#Температура на улице<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\#26.6875\#2017-06-16T16:20:01+0700\#Температура на улице<br/>
\#\#<br/>
<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\#Сервер\#55.994814\#93.029621\#175<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\#26.75\#2017-06-16T16:10:01+0700\#Температура на улице<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\#26.6875\#2017-06-16T16:15:01+0700\#Температура на улице<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\#26.6875\#2017-06-16T16:20:01+0700\#Температура на улице<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\#26.75\#2017-06-16T16:25:01+0700\#Температура на улице<br/>
\#\#<br/>

\#\*\*\*\*\*\*\*\*\*\*\*\*\#Сервер\#55.994814\#93.029621\#175<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\#26.75\#2017-06-16T16:10:01+0700\#Температура на улице<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\#26.6875\#2017-06-16T16:15:01+0700\#Температура на улице<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\#26.6875\#2017-06-16T16:20:01+0700\#Температура на улице<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\#26.75\#2017-06-16T16:25:01+0700\#Температура на улице<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\#26.8125\#2017-06-16T16:30:01+0700\#Температура на улице<br/>
\#\#<br/>
<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\#Сервер\#55.994814\#93.029621\#175<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\#26.75\#2017-06-16T16:10:01+0700\#Температура на улице<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\#26.6875\#2017-06-16T16:15:01+0700\#Температура на улице<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\#26.6875\#2017-06-16T16:20:01+0700\#Температура на улице<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\#26.75\#2017-06-16T16:25:01+0700\#Температура на улице<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\#26.8125\#2017-06-16T16:30:01+0700\#Температура на улице<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\#26.9375\#2017-06-16T16:35:01+0700\#Температура на улице<br/>
\#\#<br/>
<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\#Сервер\#55.994814\#93.029621\#175<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\#26.75\#2017-06-16T16:10:01+0700\#Температура на улице<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\#26.6875\#2017-06-16T16:15:01+0700\#Температура на улице<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\#26.6875\#2017-06-16T16:20:01+0700\#Температура на улице<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\#26.75\#2017-06-16T16:25:01+0700\#Температура на улице<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\#26.8125\#2017-06-16T16:30:01+0700\#Температура на улице<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\#26.9375\#2017-06-16T16:35:01+0700\#Температура на улице<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\#27.0625\#2017-06-16T16:40:01+0700\#Температура на улице<br/>
\#\#<br/>
OK<br/>
<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\#Сервер\#55.994814\#93.029621\#175<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\#27\#2017-06-16T16:45:01+0700\#Температура на улице<br/>
\#\#<br/>
OK<br/>
<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\#Сервер\#55.994814\#93.029621\#175<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\#26.8125\#2017-06-16T16:50:01+0700\#Температура на улице<br/>
\#\#<br/>
<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\#Сервер\#55.994814\#93.029621\#175<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\#26.8125\#2017-06-16T16:50:01+0700\#Температура на улице<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\#26.625\#2017-06-16T16:55:01+0700\#Температура на улице<br/>
\#\#<br/>
<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\#Сервер\#55.994814\#93.029621\#175<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\#26.8125\#2017-06-16T16:50:01+0700\#Температура на улице<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\#26.625\#2017-06-16T16:55:01+0700\#Температура на улице<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\#26.5\#2017-06-16T17:00:02+0700\#Температура на улице<br/>
\#\#<br/>
OK<br/>
<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\#Сервер\#55.994814\#93.029621\#175<br/>
\#\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\#26.5625\#2017-06-16T17:05:01+0700\#Температура на улице<br/>
\#\#<br/>
OK<br/>
