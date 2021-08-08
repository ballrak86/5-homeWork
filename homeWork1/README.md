## Описание файлов в директории
logFileFull.log - полный лог выполнения  
used_commands.txt - команды которые использовал

Vagrant_folder - все что понадобится для поднятия VM и краткое описание файлов в ней  
nfss_script.sh - скрипт для nfs server  
nfsc_script.sh - скрипт для nfs client  
Vagrantfile - вагрант файл  

## Описание как запустить виртуальную машину (кратко)
Выполнить команду
```
vagrant up
```
Зайти на ВМ клиента и проверить что директория /nfsdirc/upload/ доступна на запись для пользователя vagrant
```
vagrant ssh nfsc
```
Так же можно проверить что файл создался и в директории сервера /nfsdirs/upload/
```
vagrant ssh nfss
```
## Полное описание как работают скрипты.
Vagrantfile взят стандартный, его описывать не нужно.

### nfss_script.sh
```
#!/bin/bash
mkdir -p /nfsdirs/upload
```
создаем нужную нам директорию
```
chown vagrant:vagrant /nfsdirs/upload
```
назначаем владельца vagrant чтобы он мог записывать в директорию
```
echo '/nfsdirs 192.168.50.11(rw,root_squash)' > /etc/exports
```
Добавляем настройки для возможности монтиовать директорию с ip 192.168.50.11
```
systemctl enable nfs
systemctl start nfs
systemctl start firewalld
systemctl enable firewalld
```
Включаем nfs и firewalld
```
firewall-cmd --permanent --add-service=nfs
firewall-cmd --permanent --add-service=nfs3
firewall-cmd --permanent --add-service=rpc-bind
firewall-cmd --permanent --add-service=mountd
firewall-cmd --reload
```
Настраиваем файервол для монтирования nfs на клиенте

### nfsc_script.sh
```
#!/bin/bash
mkdir /nfsdirc
```
Создаем директорию, куда будем монтировать директорию nfs на сервере
```
echo '192.168.50.10:/nfsdirs /nfsdirc nfs nfsvers=3,proto=udp,timeo=5,retrans=3 0 0' >> /etc/fstab
```
Добавляем автомонтирование в /etc/fstab
```
mount /nfsdirc
```
Монтируем директорию
```
sudo -u vagrant touch /nfsdirc/upload/1.txt
```
Для проверки создаем в примонтированной директории файл
