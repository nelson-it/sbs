#!/bin/bash

#exec 1>>/tmp/dhcp.txt
#exec 2>>/tmp/dhcp.txt

domain=$(samba-tool domain info $(hostname) | egrep -i "^domain" | sed -e 's/ //g' | cut -d: -f2 )
realm=$(echo ${domain^^})

op=$1
addrtyp=$2
ip=$3
name=${4,,}
duid=$5
eval $(echo "$6" | awk -F/ '{ print "net=" $1 "; mask=" $2 }')

if [ "$name" = "n/a" ]; then
    name="dyn_$(echo $ip | sed -e "s/:/_/g" )";
fi

if [ "$addrtyp" = "AAAA" ]; then
  net=$(ipv6calc --addr2compaddr $(sipcalc $net/$mask | fgrep -i subnet | cut -d '-' -f 2))
  ip=$(ipv6calc --addr_to_fulluncompressed $ip)
  ipshort=$(ipv6calc --addr2compaddr $ip)
else
  ipshort="$ip"
fi

hostname=$(hostname)
kinit -F -k -t /var/lib/samba/dhcpd-dns/dhcpd.keytab dns-$hostname@$realm >/dev/null 2>&1
if [ "$?" != "0" ]; then
  kinit -F -k -t /var/lib/samba/dhcpd-dns/dhcpd.keytab dns-${hostname^^}@$realm
fi

case $op in
        add)
          found=$(samba-tool dns query $(hostname) "$domain" $name "$addrtyp" -k yes | awk '/^    '$addrtyp':/  { print $2;}' | \
          while read addr
          do
           if [ "$addrtyp" = "AAAA" ]; then
             addr=$(ipv6calc --addr_to_fulluncompressed $addr)
             check=$(ipv6calc --addr2compaddr $(sipcalc $addr/$mask | fgrep -i subnet | cut -d '-' -f 2))
           fi

           if [ "$check" = "$net" ]; then
             if [ "$addr" = "$ip" ]; then
               echo 1
             else
               echo samba-tool dns delete $(hostname) $domain $name $addrtyp  $addr -k yes 1>&2
               samba-tool dns delete $(hostname) $domain $name $addrtyp  $addr -k yes 1>&2
             fi
           fi
          done)

          if [ "$found" = "" ]; then
            echo samba-tool dns add $(hostname) $domain $name $addrtyp $ip -k yes
            samba-tool dns add $(hostname) $domain $name $addrtyp $ip -k yes
          else
                  echo "address $addr existiert bereits" >&2
          fi

          if [ "$duid" != "" ]; then
              if [ "$addrtyp" = "A" ]; then
                filename=/etc/dhcp/fix.conf
                idname="hardware ethernet"
                addrname="fixed-address"
              else
                filename=/etc/dhcp/fix6.conf
                idname="host-identifier option dhcp6.client-id"
                ip=$(ipv6calc --addr2compaddr $ip)
                addrname="fixed-address6"
              fi
              prog='/#[ \t]*host[ \t]+'$name'[ \t]*{/ { hostfound=1; next; }
                    /host[ \t]+'$name'[ \t]*{/        { hostfound=2; }
                    /}/                        { if ( hostfound == 1 ) { hostfound = 0; next; } }
                                               { if ( hostfound != 1 ) print $0 }
                    END                        { 
                                                 if ( hostfound !=2 )
                                                 {
                                                   printf("#   host '"$name"' {\n" );
                                                   printf("#              option host-name \"'"$name"'\";\n" );
                                                   printf("#              ddns-hostname \"'"$name"'\";\n");
                                                   printf("#              '"$idname"' '"$duid"';\n" );
                                                   printf("#              '"$addrname"' '"$ip"';\n" );
                                                   printf("#   }\n");
                                                 }
                                               }'
             cp $filename /tmp/fix$$
             awk "$prog" < /tmp/fix$$ > $filename
             rm /tmp/fix$$
          fi
        ;;

        delete)
          if [ "$addrtyp" = "AAAA" ]; then
            ip=$(ipv6calc --addr2fulluncompaddr $ip)
          fi

          prog='/^ *Name=/        { split($1,n,"="); sub(/,/,"",n[2]); name=n[2]; next}
                /^ *'$addrtyp':/  { if ( name != "" && $2 == "'$ip'" ) { print name; exit;}}'

          name=$(samba-tool dns query $(hostname) "$domain" '@' $addrtyp -k yes | awk "$prog")
          if [ "$name" != "" ]; then
            samba-tool dns delete $(hostname) $domain $name $addrtyp  $ip -k yes
          fi
        ;;
     esac

exit 0
 