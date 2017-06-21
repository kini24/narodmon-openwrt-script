# narodmon-openwrt-script
<b>Скрипт отправки данных на сервер narodmon</b><br/>
<br/>
Оборудование: D-Link DIR-825<br/>
Прошивка: OpenWrt Chaos Calmer 15.05.1<br/>
Необходимые пакеты: owserver, owshell<br/>
<br/>
Скрипт собирает данные с подключенных датчиков, формирует пакет для отправки и затем отправляет его. Делается 5 попыток отправки данных, после чего скрипт завершается для следующего вызова. Если в результате одной из попыток сервер подтвердил прием данных, скрипт завершает свою работу. В случае, если ни одна попытка не завершилась удачно, данные накапливаются во временном файле до момента пока сервер не ответит "ОК". После того, как скрипт получает потверждение об успешном приеме пакета, содержимое временного файла стирается.<br/>
В ходе работы делается форматирование данных для приведения к корректному виду (удаление лишних символов), удаляются дублирующиеся строки (например, данные об устройстве передачи). Непосредственно перед передачей пакета данных в файл добавляются закрывающие "##".
