#!/bin/bash

# 0. ecs申请下来后需要在 实例 最右面的 更多 下拉菜单中选择 密码/密钥 重置密码，设置root的密码。重启实例。
# 1. 更新系统
yum update -y	#更新linux系统
hostname Thor 
echo Thor>/etc/hostname
#5. 挂磁盘
#	# https://help.aliyun.com/document_detail/25426.html?spm=5176.208355.1107600.19.21335771o1rUUo
#	fdisk -l 
#	fdisk /dev/vdb
#		n 
#		p (default)
#		(default)
#		(default)
#		wq
#	fdisk -l 
#	mkfs.ext3 /dev/vdb1
	
# 2. 装jdk
# 上传rpm包
cd /home
# yum install lrzsz -y
# rz
rpm -ivh jdk-8u161-linux-x64.rpm
cd /usr/java
chmod +x -R jdk1.8.0_161/
# profile文件中添加如下内容
cat<<EOF>>/etc/profile
#set java environment
JAVA_HOME=/usr/java/jdk1.8.0_161
JRE_HOME=/usr/java/jdk1.8.0_161/jre
CLASS_PATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib
PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin
export JAVA_HOME JRE_HOME CLASS_PATH PATH
EOF
source /etc/profile
java -version
javac -version

# 3. 装mysql
# 下载mysql源安装包
cd /home
wget https://dev.mysql.com/get/mysql80-community-release-el7-1.noarch.rpm
# 安装mysql源
yum localinstall mysql80-community-release-el7-1.noarch.rpm -y
# 检查mysql源是否安装成功
yum repolist enabled | grep "mysql.*-community.*"
# 修改vim /etc/yum.repos.d/mysql-community.repo源，改变默认安装的mysql版本
sed -i '13s#0#1#g' /etc/yum.repos.d/mysql-community.repo
sed -i '28s#1#0#g' /etc/yum.repos.d/mysql-community.repo
# Enable to use MySQL 5.6
# [mysql56-community]
# name=MySQL 5.6 Community Server
# baseurl=http://repo.mysql.com/yum/mysql-5.6-community/el/7/$basearch/
# enabled=1	# 1是安装，0是不安装
# gpgcheck=1
# gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-mysql
# 安装MySQL
yum install -y mysql-community-server
# mysql 文件夹
# 默认 /var/lib/mysql
# 挂载磁盘并添加开机启动
# mount /dev/vdb1 /var/lib/mysql
# echo 
# 启动MySQL服务
systemctl start mysqld
# 查看MySQL的启动状态
systemctl status mysqld
# 开机启动
systemctl enable mysqld
systemctl daemon-reload
# # 登录mysql，修改密码，5.6默认密码为空
# mysql -u root -p
# # 查看原有的配置
# select host,user,password from mysql.user;
# # 使用update修改密码
# update mysql.user set password=password('Que1805*') where user='root';
# # 配置mysql访问权限
# # https://blog.csdn.net/warrior_wjl/article/details/37935733
# use mysql;
# select host, user from user;
# GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'Que1805*' WITH GRANT OPTION;
# select host, user from user;
# flush privileges;

# 4. 放开阿里云策略端口 80(httpd) 3306(mysql)





