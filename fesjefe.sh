#!/bin/bash
exist=`ldapsearch -x -b "dc=tomasruiz,dc=jmir" -H ldap://10.110.34.10 -D "cn=admin,dc=tomasruiz,dc=jmir" -w alumne -LLL "(uid=$1)" | grep uid: | cut -f2 -d":"`
if [ $# -lt 2 -o $# -gt 2 ];
then
		echo "u need to give me: script.sh username route_for_comand"
else
if [ $exist == "$1" ];
then
echo """dn: cn=$1,ou=SUDOers,dc=tomasruiz,dc=jmir
objectClass: top
objectClass: sudoRole
cn: $1
sudoUser: $1
sudoHost: ALL
sudoCommand: $2""">sudo$1.ldif

ldapadd -H ldap://10.110.34.10 -x -D "cn=admin, dc=tomasruiz, dc=jmir" -w alumne -f sudo$1.ldif

echo "se agrego $1 a sudoers ldap"
rm sudo$1.ldif

else
	echo "user $1 does not exist"
fi
fi

