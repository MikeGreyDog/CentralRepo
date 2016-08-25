#!/bin/bash/

hosts_file="hostnames.txt"
hosts_ip=$(grep "ip" $hosts_file | cut -f2 -d ":")
config_file="/opt/configs/sampleconfig.conf"
echo $hosts_ip

commands1='mkdir /opt/java_jre;
	  mkdir /opt/configs;
	  wget --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u102-b14/jre-8u102-linux-x64.tar.gz" -O jre-8u102-linux-x64.tar.gz;
	  tar -xzvf jre-8u102-linux-x64.tar.gz -C /opt/java_jre;
	  source /root/sourcefile;
	  java -version;
	  echo "Binary=$JAVA_HOME/bin" >> /opt/configs/sampleconfig.conf'

commands2='mkdir /opt/configs;
	  yum install jss.x86_64 -y;
	  java -version;
	  echo "Binary=/usr/java/jdk1.8.0.102/bin" >> /opt/configs/sampleconfig.conf'

for host in $hosts_ip
do
 if [[ $1 ]]; then
   case "$1" in
    -j)  scp sourcefile root@$host:/root/sourcefile
	scp sampleconfig.conf root@$host:$config_file
	ssh root@$host $commands1
	echo "Server=$host" | ssh root@$host 'cat >> /opt/configs/sampleconfig.conf'
	rm -f /root/sourcefile
	;;
    *)
	echo "Wrong parametr. Use |-j to download and install jre archive| or do not set any parameters to install jre using YUM"
	;;
   esac
 else
	scp sampleconfig.conf root@$host:$configfile
	ssh root@$host $commands2
	echo "Server=$host" | ssh root@$host 'cat >> /opt/configs/sampleconfig.conf'
	
 fi
done


