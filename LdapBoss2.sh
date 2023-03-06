#!/bin/bash
exist=`ldapsearch -x -b "dc=tomasruiz,dc=jmir" -H ldap://10.110.34.10 -D "cn=admin,dc=tomasruiz,dc=jmir" -w alumne -LLL "(uid=$1)" | grep uid: | cut -f2 -d":"`
excomnd=`ldapsearch -x -b "ou=SUDOers,dc=tomasruiz,dc=jmir" -H ldap://10.110.34.10 -D "cn=admin,dc=tomasruiz,dc=jmir" -w alumne -LLL "(sudoUser=$1)" | grep sudoCommand: | cut -f2 -d":"`
if [ $# -lt 2 ];
then
                echo "u need to give me: script.sh username comand"
else

        if [ $exist == "$1" ];
        then
        #creo dos archivos
                echo """dn: cn=$1,ou=SUDOers,dc=tomasruiz,dc=jmir
objectClass: top
objectClass: sudoRole
cn: $1
sudoUser: $1
sudoHost: ALL
sudoRunAs: ALL""">sudo$1.ldif

                echo """dn: cn=$1,ou=SUDOers,dc=tomasruiz,dc=jmir
changetype: modify
add: sudoCommand""">mod$1.ldif

                #agregos los comandos

                for i  in "${@:2}"
                do
                estado=0
                        for x in $excomnd
                        do
                                if [ "$x" == "$i" ];
                                then
                                        estado=1
                                        echo $estado
                                fi
                        done
                        if [ $estado == 0 ]
                        then
                                echo $estado
                                echo "sudoCommand: $i">>sudo$1.ldif
                                echo "sudoCommand: $i">>mod$1.ldif
                        fi
                done
                cat sudo$1.ldif
                cat mod$1.ldif

        #controlo agregarlo o modificarlo
                ldapadd -H ldap://10.110.34.10 -x -D "cn=admin, dc=tomasruiz, dc=jmir" -w alumne -f sudo$1.ldif || ldapmodify -H ldap://10.110.34.10 -x -D "cn=admin, dc=tomasruiz, dc=jmir" -w alumne -f mod$1.ldif
                echo "operacion sobre $1 en sudoldap realizada satifactoriamente"
                #rm sudo$1.ldif
                #rm mod$1.ldif
        else
                echo "user $1 does not exist"
        fi
fi

