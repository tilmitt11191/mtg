

## package check
#linux applications
echo "package check"
PACKAGES=(git mysql-server libmysqlclient-dev ruby ruby-dev libxml2 libxml2-dev libxslt-dev zlib1g-dev)
for package in ${PACKAGES[@]}; do
	dpkg -l $package > /dev/null 2>&1
	if [ $? -ne 0 ];then
		echo "apt-get install -y $package."
		sudo apt-get install -y $package
	fi
done

#gem packages
PACKAGES=(nokogiri activesupport activerecord mysql2)
for package in ${PACKAGES[@]}; do
	gem list | grep $package > /dev/null 2>&1
	if [ $? -ne 0 ];then
		echo "sudo gem install $package"
		sudo gem install $package
	fi
done
