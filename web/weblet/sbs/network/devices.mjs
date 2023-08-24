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

        cols        : 'device,config',
        tablecoltype: {  config : 'mtext' },

        modurl  : 'sysexec/sbs/network/devices_ok',
        modcols : ['device','config'],
        
        delurl  : 'sysexec/sbs/network/devices_del',
        delids  : ['device'],
        delconfirmids : [ 'device'],
        
        nomodifyok : true
    };
    
    super(parent, frame, id, Object.assign(ivalues, initpar), config );
  }
}

export default MneSbsNetworkDevices
