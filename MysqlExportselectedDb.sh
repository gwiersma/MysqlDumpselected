#!/bin/bash
 
#####
# Set these values!
####
 
 
# space seperated list of domain names (will be used as part of the output path)
domains=( name4subfolders inSQLfolderabove canbedomains orsomethingelse )
#list of corresponding DB names
sqldbs=( fulldbname1 db2 db3 db4 )
 
#list of IDs and passwords
username=[username]
password=[password]
 
#Directory to save generated sql files (domain name is appended)
opath=$HOME/sql_dumps/
 
# your mysql host
mysqlhost=[host]
 
 
 
#####
# End of config values
#####
 
 
 
 
#run on each domain
for (( i = 0 ; i < ${#domains[@]} ; i++ ))
do
	#set current output path
	cpath=$opath${domains[$i]}
 
	#check if we need to make path
	if [ -d $cpath ]
	then
		# direcotry exists, we're good to continue
		filler="just some action to prevent syntax error"
	else
		#we need to make the directory
		echo Creating $cpath
		mkdir -p $cpath
	fi
 
	#now do the backup
	SQLFILE=${cpath}/${sqldbs[$i]}.sql
 
	mysqldump -c -h $mysqlhost --user $username --password=$password ${sqldbs[$i]} 2>error |  > $SQLFILE
 
	if [ -s error ]
	then	   
		printf "WARNING: An error occured while attempting to backup %s  \n\tError:\n\t" ${sqldbs[$i]} 
		cat error
		rm -f er
	else
		printf "%s was backed up successfully to %s\n\n" ${sqldbs[$i]} $SQLFILE
	fi
done
