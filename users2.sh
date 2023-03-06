#!/bin/bash
if [ $# -lt 3 -o $# -gt 3 ];
then
        echo "u need to give me: script.sh username pass gid"
else

gid=`ldapsearch -x -b "ou=groups,dc=tomasruiz,dc=jmir" -H ldap://10.110.34.10 cn=$3 | grep gidNumber: | cut -f2 -d":"`

uid=`ldapsearch -x -b "ou=users,dc=tomasruiz,dc=jmir" -H ldap://10.110.34.10 | grep uidNumber: | cut -f2 -d":" | sort -n | tail -1`
num=$((uid+1))

if [ $gid -eq 1001 ];
then
echo """dn:cn=$1,ou=users,dc=tomasruiz,dc=jmir
cn: $1
sn: $1
objectClass: person
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: top
uid: $1
uidNumber: $num
gidNumber: $gid
homeDirectory: /home/professors/$1
loginShell: /bin/bash""">$1.ldif
elif [ $gid -eq 1002 ];
then
echo """dn:cn=$1,ou=users,dc=tomasruiz,dc=jmir
cn: $1
sn: $1
objectClass: person
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: top
uid: $1
uidNumber: $num
gidNumber: $gid
homeDirectory: /home/alumnes/$1
loginShell: /bin/bash""">$1.ldif
fi
ldapadd -H ldap://10.110.34.10 -x -D "cn=admin, dc=tomasruiz, dc=jmir" -w alumne -f $1.ldif
ldappasswd -H ldap://10.110.34.10 -s $2 -x -D "cn=admin,dc=tomasruiz,dc=jmir" -W "cn=$1,ou=users,dc=tomasruiz,dc=jmir"
fi

