
;---------------------------------------------------------------------------------------------------
;	BATCH COMMANDS (BASH)
;---------------------------------------------------------------------------------------------------
:*:genkey::keytool -genkey -alias __key_name__ -keyalg RSA -keysize 2048 -validity 36500 -keystore D:\Documents\__app_name__.keystore{Left 9}
:*:regdom::echo 127.0.0.1  >> C:\Windows\System32\drivers\etc\hosts{left 41}
:*:addport::firewall-cmd --zone=public --add-port=/tcp --permanent{left 16}
:*:pxlsread::python \xlsread.py F:\Documents\宝塔\
;---------------------------------------------------------------------------------------------------
; BT Tools
;---------------------------------------------------------------------------------------------------
:*R:installbt::yum install -y wget && wget -O install.sh http://download.bt.cn/install/install_6.0.sh && sh install.sh -y
:*R:removebt::/etc/init.d/bt stop rm -f /etc/init.d/bt rm -rf /www/server/panel
:*R:uninstallbt::wget http://download.bt.cn/install/bt-uninstall.sh; sh bt-uninstall.sh
:*R:btuninstall::wget http://download.bt.cn/install/bt-uninstall.sh; sh bt-uninstall.sh


:*R:updatemoni::cd /home/www/control_svrs/ && bash control_svrs.sh --update-monitor
:*R:tldelall::cd /home/www/control_svrs/ && bash control_svrs.sh --delete-file
:*R:tlsyncall::cd /home/www/control_svrs/ && bash control_svrs.sh --sync-file
:*R:tlfindall::cd /home/www/control_svrs/ && bash control_svrs.sh --find-keyword
:*R:curlhttp::curl -o /dev/null -A mobile -s -w "%{http_code}\n"

;---------------------------------------------------------------------------------------------------
; shell commands (Linux)
;---------------------------------------------------------------------------------------------------
:*R:rsyncall::rsync -av --exclude="site/*" --exclude='runtime/*' -e 'ssh -p __default_port__' --max-size=100m /home/www/wwwroot/ root@__default_ip__:/home/www/wwwroot/
:*R:sitex::sqlite3 -separator $'\t' /www/server/panel/data/db/site.db 'select id, status, name, path from sites order by addtime desc;'
:*R:getservice::systemctl list-units --type=service
:*R:servicelist::systemctl list-units --type=service
:*:filelist::find / -maxdepth 8 -regex '.*\(proc\|file_history\|proxy_cache_dir\|http_log\|wwwlogs\|home\)' -prune -o -type f -print | sort > /file_list.txt
:*:getfile::find / -maxdepth 8 -regex '.*\(proc\|file_history\|proxy_cache_dir\|http_log\|wwwlogs\|home\)' -prune -o -type f -print | sort > /file_list.txt
:*:osrelease::cat /etc/os-release
:*:getsystem::cat /etc/os-release
:*:getos::cat /etc/os-release
:*:systeminfo::cat /etc/os-release
:*:svrinfo::hostnamectl
:*:myip::curl ip.sb
:*:getip::curl ifconfig.me
:*R:getmyip::echo $SSH_CLIENT | awk '{print $1}'
:*R:getcltip::echo $SSH_CLIENT | awk '{print $1}'
:*R:getsvrip::hostname -I | awk '{print $1}'
:*R:getsvrls::hostname -I | tr ' ' '\n'
:*R:btgetip::cat /www/server/panel/data/iplist.txt
:*R:getbt::python -c "import json; import sys; print(json.load(open('/www/server/panel/config/config.json'))['title'])"
:*R:btname::python -c "import json; import sys; print(json.load(open('/www/server/panel/config/config.json'))['title'])"

;---------------------------------------------------------------------------------------------------
; RANDOM
;---------------------------------------------------------------------------------------------------
; IfWinActive directive for the window group
#IfWinActive ahk_group COMMANDER
:*R:randport::powershell -Command "(Get-Random -Minimum 8888 -Maximum 65536)"
:*R:randpass::powershell -Command "$length=16; $chars='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*.'; -join ((1..$length) | ForEach-Object { $chars[(Get-Random -Maximum $chars.Length)] })"
:*R:randpath::powershell -Command "$length=16; $chars='abcdefghijklmnopqrstuvwxyz0123456789'; -join ((1..$length) | ForEach-Object { $chars[(Get-Random -Maximum $chars.Length)] })"
:*R:randuser::powershell -Command "$length=16; $chars='abcdefghijklmnopqrstuvwxyz'; -join ((1..$length) | ForEach-Object { $chars[(Get-Random -Maximum $chars.Length)] })"
:*:debase::powershell -Command "[Text.Encoding]`:`:UTF8.GetString([Convert]`:`:FromBase64String(''))"{left 4}
#If  ; End context sensitivity
:*R:randport::echo $((RANDOM%65535+8888))
;~ :*R:randpass::cat /dev/urandom | tr -dc '[:alpha:]' | fold -w 16 | head -n 1
;~ :*R:randpass::cat /dev/urandom | tr -dc '[:alnum:]!@#$%^&*.' | fold -w 16 | head -n 1
;~ :*R:randpass::cat /dev/urandom | tr -dc '[:alnum:]@#$%&.' | fold -w 16 | head -n 1
:*R:randpass::cat /dev/urandom | tr -dc '[:alnum:]' | fold -w 16 | head -n 1
:*R:randpath::echo $RANDOM | md5sum | head -c 20; echo;
:*R:randuser::cat /dev/urandom | tr -dc 'a-z' | fold -w 16 | head -n 1
:*R:zstart::/opt/zbox/zbox --aport 8080 --mport 3307 start
:*:debase::echo -n "" | base64 -d `; echo {left 21}



;---------------------------------------------------------------------------------------------------
;	TOP COMMANDS
;---------------------------------------------------------------------------------------------------
; apache
:*R:topaip::awk '{ print $1}' /www/wwwlogs/*_log | sort | uniq -c | sort -nr | head -n 20
:*R:topafip::awk '{ print $1, FILENAME}' /www/wwwlogs/*_log | sort | uniq -c | sort -nr | head -n 20
:*R:topaeclt::awk '{match($0, /[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/, ip); if (ip[0] != "") print ip[0]}' /www/wwwlogs/*error_log | sort | uniq -c | sort -nr | head -n 20

;-----------------------------------------
; nginx
:*R:topnetsvr::netstat -an|awk  '{print $4}'|sort|uniq -c|sort -nr|head
:*R:topnetclt::netstat -an | awk '{split($5, a, ":"); print a[1]}' | sort | uniq -c | sort -nr|head -n 20

:*R:topsrvip::netstat -an|awk  '{print $4}'|sort|uniq -c|sort -nr|head
:*R:topcltip::netstat -an | awk '{split($5, a, ":"); print a[1]}' | sort | uniq -c | sort -nr|head -n 20
:*R:toppairip::netstat -ntu | awk '{print $4"\t"$5;}' | egrep -v 127.0.0.1 | sort | uniq -c | sort -n
:*R:topstate::netstat -an|awk  '{print $6}'|sort|uniq -c|sort -nr|head
:*R:topclassip::netstat -ntu|awk '{print $5}'|cut -d: -f1 -s |cut -f1,2,3 -d'.'|sed 's/$/.0/'|sort|uniq -c|sort -nk1 -r | head -n 20
:*R:topport80::netstat -aon | grep :80
:*R:topport443::netstat -aon | grep :443
:*R:topest::netstat -n | grep EST

;-----------------------------------------

:*R:topsql::awk -F ';' '{ print $1}' /www/server/data/mysql-slow.log | sort | uniq -c | sort -nr | head -n 20

:*R:toppostip::grep "POST" /www/wwwlogs/*.log | awk '{ print $1 }' | sort | uniq -c | sort -nr | head -n 20
:*R:topposturi::grep "POST" /www/wwwlogs/*.log | awk -F'"' '{print $2}' | sort | uniq -c | sort -nr | head -n 20
:*R:toppoststatus::grep "POST" /www/wwwlogs/*.log | awk -F'"' '{print $2, $3}' | sort | uniq -c | sort -nr | head -n 20

:*R:topip::awk '{ print $1}' /www/wwwlogs/*.log | sort | uniq -c | sort -nr | head -n 20
:*R:topuri::awk -F'"' '{print $2}' /www/wwwlogs/*.log | sort | uniq -c | sort -nr | head -n 20
:*R:toprfr::awk -F'"' '{print $4}' /www/wwwlogs/*.log | sort | uniq -c | sort -nr | head -n 20
:*R:topfrm::awk -F'"' '{print $4}' /www/wwwlogs/*.log | sort | uniq -c | sort -nr | head -n 20
:*R:topua::awk -F'"' '{print $6}' /www/wwwlogs/*.log | sort | uniq -c | sort -nr | head -n 20
:*R:topstatus::awk -F'"' '{sub(/\[.*\]/, "", $1); split($3, http, " "); print $1, http[length(http)-1]}' /www/wwwlogs/*.log | sort | uniq -c | sort -nr | head -n 20


:*R:toperr::awk -F'"' '{print $1}' /www/wwwlogs/*.error.log | sort | uniq -c | sort -nr | head -n 20
:*R:topersn::awk -F'"' '{print $3}' /www/wwwlogs/*.error.log | sort | uniq -c | sort -nr | head -n 20
:*R:toperqt::awk -F'"' '{print $4}' /www/wwwlogs/*.error.log | sort | uniq -c | sort -nr | head -n 20
:*R:topeuri::awk -F'"' '{print $4}' /www/wwwlogs/*.error.log | sort | uniq -c | sort -nr | head -n 20
:*R:topedom::awk -F'"' '{print $6}' /www/wwwlogs/*.error.log | sort | uniq -c | sort -nr | head -n 20
:*R:topehst::awk -F'"' '{print $6}' /www/wwwlogs/*.error.log | sort | uniq -c | sort -nr | head -n 20
:*R:toperfr::awk -F'"' '{print $8}' /www/wwwlogs/*.error.log | sort | uniq -c | sort -nr | head -n 20

:*:topsite::awk '{{} print $1 {}}' /www/wwwlogs/.log | sort | uniq -c | sort -nr | head -n 20{left 45}

:*R:topfip::awk '{ print $1, FILENAME}' /www/wwwlogs/*.log | sort | uniq -c | sort -nr | head -n 20
:*R:topfuri::awk -F'"' '{print $2, FILENAME}' /www/wwwlogs/*.log | sort | uniq -c | sort -nr | head -n 20
:*R:topfrfr::awk -F'"' '{print $4, FILENAME}' /www/wwwlogs/*.log | sort | uniq -c | sort -nr | head -n 20
:*R:topffrm::awk -F'"' '{print $4, FILENAME}' /www/wwwlogs/*.log | sort | uniq -c | sort -nr | head -n 20

:*R:topefrqt::awk -F'"' '{print $4, FILENAME}' /www/wwwlogs/*.error.log | sort | uniq -c | sort -nr | head -n 20

:*R:topeall::awk -F',' '{print $1}' /www/wwwlogs/*.error.log | sort | uniq -c | sort -nr | head -n 20
:*R:topeip::awk -F',' '{print $2}' /www/wwwlogs/*.error.log | sort | uniq -c | sort -nr | head -n 20
:*R:topeclt::awk -F',' '{print $2}' /www/wwwlogs/*.error.log | sort | uniq -c | sort -nr | head -n 20
:*R:topesvr::awk -F',' '{print $3}' /www/wwwlogs/*.error.log | sort | uniq -c | sort -nr | head -n 20
:*R:toperqt::awk -F',' '{print $4}' /www/wwwlogs/*.error.log | sort | uniq -c | sort -nr | head -n 20
:*R:topehst::awk -F',' '{print $5}' /www/wwwlogs/*.error.log | sort | uniq -c | sort -nr | head -n 20
:*R:toperfr::awk -F',' '{print $7}' /www/wwwlogs/*.error.log | sort | uniq -c | sort -nr | head -n 20

:*R:topefclt::awk -F',' '{print $2,FILENAME}' /www/wwwlogs/*.error.log | sort | uniq -c | sort -nr | head -n 20

:*R:tope1::awk -F'"' '{print $1}' /www/wwwlogs/*.error.log | sort | uniq -c | sort -nr | head -n 20
:*R:tope3::awk -F'"' '{print $3}' /www/wwwlogs/*.error.log | sort | uniq -c | sort -nr | head -n 20
:*R:tope4::awk -F'"' '{print $4}' /www/wwwlogs/*.error.log | sort | uniq -c | sort -nr | head -n 20
:*R:tope6::awk -F'"' '{print $6}' /www/wwwlogs/*.error.log | sort | uniq -c | sort -nr | head -n 20
:*R:tope8::awk -F'"' '{print $8}' /www/wwwlogs/*.error.log | sort | uniq -c | sort -nr | head -n 20

:*R:topc1::awk -F',' '{print $1}' /www/wwwlogs/*.error.log | sort | uniq -c | sort -nr | head -n 20
:*R:topc2::awk -F',' '{print $2}' /www/wwwlogs/*.error.log | sort | uniq -c | sort -nr | head -n 20
:*R:topc3::awk -F',' '{print $3}' /www/wwwlogs/*.error.log | sort | uniq -c | sort -nr | head -n 20
:*R:topc4::awk -F',' '{print $4}' /www/wwwlogs/*.error.log | sort | uniq -c | sort -nr | head -n 20
:*R:topc5::awk -F',' '{print $5}' /www/wwwlogs/*.error.log | sort | uniq -c | sort -nr | head -n 20
:*R:topc6::awk -F',' '{print $6}' /www/wwwlogs/*.error.log | sort | uniq -c | sort -nr | head -n 20
:*R:topc7::awk -F',' '{print $7}' /www/wwwlogs/*.error.log | sort | uniq -c | sort -nr | head -n 20

:*R:topl1::awk -F':' '{print $1}' /www/wwwlogs/*.error.log | sort | uniq -c | sort -nr | head -n 20
:*R:topl2::awk -F':' '{print $2}' /www/wwwlogs/*.error.log | sort | uniq -c | sort -nr | head -n 20
:*R:topl3::awk -F':' '{print $3}' /www/wwwlogs/*.error.log | sort | uniq -c | sort -nr | head -n 20
:*R:topl4::awk -F':' '{print $4}' /www/wwwlogs/*.error.log | sort | uniq -c | sort -nr | head -n 20
:*R:topl5::awk -F':' '{print $5}' /www/wwwlogs/*.error.log | sort | uniq -c | sort -nr | head -n 20
:*R:topl6::awk -F':' '{print $6}' /www/wwwlogs/*.error.log | sort | uniq -c | sort -nr | head -n 20
:*R:topl7::awk -F':' '{print $7}' /www/wwwlogs/*.error.log | sort | uniq -c | sort -nr | head -n 20
:*R:topl8::awk -F':' '{print $8}' /www/wwwlogs/*.error.log | sort | uniq -c | sort -nr | head -n 20
:*R:topl9::awk -F':' '{print $9}' /www/wwwlogs/*.error.log | sort | uniq -c | sort -nr | head -n 20



;---------------------------------------------------------------------------------------------------
;	HOTSTRINGS
;---------------------------------------------------------------------------------------------------



:*:phpline::echo '-----'.PHP_EOL
:*:eol::PHP_EOL

:~:*:dc::được

;---------------------------------------------------------------------------------------------------
; OTHERS
;---------------------------------------------------------------------------------------------------
:*R:gettrace::$e = new \Exception; var_dump($e->getTraceAsString());
:*R:phpdebug::$e = new \Exception; var_dump($e->getTraceAsString());

;~ :*r:findhome::find /home/www/wwwroot/ -type f -exec grep -H "" {} +
:*:findhome::find /home/www/wwwroot/ -type f -exec grep -H "" {{}{}} {+}{Left 6}
:*:findlog::find /www/wwwlogs/ -type f -exec grep -H "" {{}{}} {+}{Left 6}
:*:findsys::find /www/server/ -type f -exec grep -H "" {{}{}} {+}{Left 6}

:*:sqlsite::sqlite3 /www/server/panel/data/db/site.db;
:*:selectsite::select id,name,path from sites order by addtime desc;

;~ :*Rb0:{php}::{/php}:R0:{Left 6}
:*b0:{php}::{{}/php{}}{Left 6}
:*:vard::var_dump();{left 2}
:*:rpnt::print_r();{left 2}
:*:clog::console.log();{left 2}
:*:mshow::MessageBox.Show();{left 2}
:*:cwrite::Console.WriteLine(string.Join(", ", ));{left 3}

;---------------------------------------------------------------------------------------------------