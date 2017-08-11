#!/bin/bash
 
#####
# Set these values!
####
 

#list of corresponding DB names seperated by spaces
sqldbs=( db1 db2 ) 
 
#list of IDs and passwords
username=<user>
password=<pass>
 
#Directory to save generated sql files (domain name is appended)
opath=$HOME/sql_dumps/
 
# your mysql host
mysqlhost=<dbhost>
 
 
 
#####
# End of config values
#####
 
 
 
 
#run on each domain
for (( i = 0 ; i < ${#sqldbs[@]} ; i++ ))
do
	#set current output path
	cpath=$opath
 
	#check if we need to make path
	if [ -d $opath ]
	then
		# direcotry exists, we're good to continue
		filler="just some action to prevent syntax error"
	else
		#we need to make the directory
		echo Creating $opath
		mkdir $opath
	fi
 
	#now do the backup
	SQLFILE=$HOME/backups/${sqldbs[$i]}.sql
 
	mysqldump -c -h $mysqlhost --user $username --password=$password ${sqldbs[$i]} 2>error  > $SQLFILE
 
	if [ -s error ]
	then	   
		printf "WARNING: An error occured while attempting to backup %s  \n\tError:\n\t" ${sqldbs[$i]} 
		cat error
		rm -f er
	else
		printf "%s was backed up successfully to %s\n\n" ${sqldbs[$i]} $SQLFILE
	fi
done
