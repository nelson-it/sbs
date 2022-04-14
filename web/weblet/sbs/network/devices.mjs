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
        primarykey : ['device'],

        cols        : 'device,netaddrtyp,netaddr6,netaddr,netbcast,netgateway,dnsnameserver,dnssearch,wlan,wlanpass,wlanhidden,readtime',
        tablecoltype: {  netaddrtyp : 'selection', netaddr : 'mtext', netaddr6: 'mtext', netbcast: 'text', netgateway: 'text', dnssearch : 'text', 'dnsnameserver' : 'mtext', dnsdomain : 'text', wlan : 'text', wlanpass : "text", wlanhidden : 'bool' },

        modurl  : 'sysexec/sbs/network/devices_ok',
        modcols : ['device','netaddrtyp', 'netaddr6','netaddr','netbcast','netgateway','dnsnameserver','dnssearch','wlan','wlanpass','wlanhidden'],
        
        delurl  : 'sysexec/sbs/network/devices_del',
        delids  : ['device'],
        delconfirmids : [ 'device'],
        
        applyurl : '/weblet/sbs/network/devices_apply'
    };
    
    super(parent, frame, id, Object.assign(ivalues, initpar), config );
  }
}

export default MneSbsNetworkDevices
