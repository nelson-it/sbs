//================================================================================
//
// Copyright: M.Nelson - technische Informatik
// Die Software darf unter den Bedingungen 
// der APGL ( Affero Gnu Public Licence ) genutzt werden
//
// datei: sbs/network/devices.mjs
//================================================================================
'use strict';

import MneTableWeblet from '/weblet/allg/table/fix.mjs'

class MneSbsNetworkDevices extends MneTableWeblet
{
  constructor(parent, frame, id, initpar = {}, config = {} )
  {
    var ivalues = 
    {
        tableweblet : '/weblet/sbs/network/devicestable',
        
        url        : 'sysexec/sbs/network/devices_read',
        primarykey : ['file'],

        cols        : 'file,config',
        tablecoltype: {  file : 'text', config : 'mtext' },

        addurl  : 'sysexec/sbs/network/devices_ok',
        modurl  : 'sysexec/sbs/network/devices_ok',
        okids   : ['file'],
        okcols : ['file','config'],
        
        delurl  : 'sysexec/sbs/network/devices_del',
        delids  : ['file'],
        delconfirmids : [ 'file'],
        
        defvalues : { file : "", config : "#network:\n"
                                        + "#  version: 2\n"
                                        + "#  ethernets:\n"
                                        + "#    en0:\n"
                                        + "#      dhcp4: false\n"
                                        + "#      dhcp6: false\n"
                                        + "#      accept-ra: false\n"
                                        + "#      addresses:\n"
                                        + "#        - 192.168.83.10/24\n"
                                        + "#        - fd01:4687::10/64\n"
                                        + "#      routes:\n"
                                        + "#        - to: default\n"
                                        + "#          via: 192.168.83.1\n"
                                        + "#        - to: \"::/0\"\n"
                                        + "#          via: \n"
                                        + "#      nameservers:\n"
                                        + "#        addresses: [127.0.0.1]\n"
                                        + "#        search: []\n"
                                        + "#  wifis:\n"
                                        + "#    wifi0:\n"
                                        + "#      dhcp4: false\n"
                                        + "#      dhcp6: false\n"
                                        + "#      accept-ra: false\n"
                                        + "#      addresses:\n"
                                        + "#        - 192.168.83.11/24\n"
                                        + "#        - fd01:4687::11/64\n"
                                        + "#      routes:\n"
                                        + "#        - to: default\n"
                                        + "#          via: 192.168.83.1\n"
                                        + "#        - to: \"::/0\"\n"
                                        + "#          via: \n"
                                        + "#      nameservers:\n"
                                        + "#        addresses: [127.0.0.1]\n"
                                        + "#        search: []\n"
                                        + "#      access-points:\n"
                                        + "#        \"MyWlanID\":\n"
                                        + "#           hidden: false\n"
                                        + "#           password: \"MyWlanPass\"\n"
  
            },
        
        nomodifyok : true
    };
    
    super(parent, frame, id, Object.assign(ivalues, initpar), config );
  }
}

export default MneSbsNetworkDevices
