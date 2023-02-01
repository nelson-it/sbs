#!/bin/bash

#exec 1>>/tmp/dhcp.txt
#exec 2>>/tmp/dhcp.txt

domain=$(samba-tool domain info $(hostname) | egrep -i "^domain" | sed -e 's/ //g' | cut -d: -f2)
realm=$(echo ${domain^^})

op=$1
addrtyp=$2
ip=$3
name=${4,,}
duid=$5
if [ "$addrtyp" = "AAAA" ]; then
  eval $(echo "$6" | awk -F/ '{ print "net=" $1 "; mask=" $2 }')
else
  mask=$6
fi

if [ "$name" = "n/a" ]; then
  name="dyn_$(echo $ip | sed -e "s/:/_/g")"
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

function get_reverse() {
  if [ "$addrtyp" = "AAAA" ]; then
    let num=$2/4
    zone="$(ipv6calc -a -I ipv6addr $1/$2 | sed -e 's/\.$//')"
    raddr="$(ipv6calc -a -I ipv6addr $1 | tr "." $'\n' | head -n $num | paste -s -d '.')"
  else
    num="$(echo $2 | awk -v RS=. 'BEGIN { num=0 } { if ( $0 == "255" ) num++ } END { print num}')"
    zone="$(echo $1 | tr -d "[:blank:]" | cut -d/ -f1 | tr "." $'\n' | head -n $num | tac | paste -s -d '.').in-addr.arpa"
    let num=4-$num
    raddr="$(echo $1 | tr -d "[:blank:]" | cut -d/ -f1 | tr "." $'\n' | tail -$num | tac | paste -s -d '.')"
  fi
}

function del_wrong_addr() {
  found=$(samba-tool dns query $(hostname) "$domain" $name "$addrtyp" --use-kerberos=required | awk '/^    '$addrtyp':/  { print $2;}' |
    while read addr; do
      if [ "$addrtyp" = "AAAA" ]; then
        addr=$(ipv6calc --addr_to_fulluncompressed $addr)
        check=$(ipv6calc --addr2compaddr $(sipcalc $addr/$mask | fgrep -i subnet | cut -d '-' -f 2))
      fi

      if [ "$check" = "$net" ]; then
        if [ "$addr" = "$ip" ]; then
          echo 1
        else
          echo samba-tool dns delete $(hostname) $domain $name $addrtyp $addr 1>&2
          samba-tool dns delete $(hostname) $domain $name $addrtyp $addr --use-kerberos=required 1>&2

          get_reverse "$addr" "$mask" 1>&2
          echo samba-tool dns delete $(hostname) $zone $raddr PTR $name.$domain 1>&2
          samba-tool dns delete $(hostname) $zone $raddr PTR $name.$domain --use-kerberos=required 1>&2
        fi
      fi
    done)
}

case $op in
  add)
    del_wrong_addr

    if [ "$found" = "" ]; then
      echo samba-tool dns add $(hostname) $domain $name $addrtyp $ip --use-kerberos=required
      samba-tool dns add $(hostname) $domain $name $addrtyp $ip --use-kerberos=required
      if [ "${4,,}" != "n/a" ]; then
	      get_reverse "$ip" "$mask"
        echo samba-tool dns add $(hostname) $domain $name $addrtyp $ip --use-kerberos=required
        samba-tool dns add $(hostname) $zone $raddr PTR $name.$domain --use-kerberos=required 1>&2
      fi
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
      awk "$prog" </tmp/fix$$ >$filename
      rm /tmp/fix$$
    fi
    ;;

  del)
    if [ "$addrtyp" = "AAAA" ]; then
      ip=$(ipv6calc --addr2fulluncompaddr $ip)
    fi

    prog='/^ *Name=/        { split($1,n,"="); sub(/,/,"",n[2]); name=n[2]; next}
                /^ *'$addrtyp':/  { if ( name != "" && $2 == "'$ip'" ) { print name; exit;}}'

    name=$(samba-tool dns query $(hostname) "$domain" '@' $addrtyp --use-kerberos=required | awk "$prog")
    if [ "$name" != "" ]; then
      samba-tool dns delete $(hostname) $domain $name $addrtyp $ip --use-kerberos=required
      get_reverse "$ip" "$mask"
      samba-tool dns delete $(hostname) $zone $raddr PTR $name.$domain --use-kerberos=required 1>&2
    fi
    ;;
esac

exit 0
