//================================================================================
//
// Copyright: M.Nelson - technische Informatik
// Die Software darf unter den Bedingungen 
// der APGL ( Affero Gnu Public Licence ) genutzt werden
//
// datei: sbs/network/devices.mjs
//================================================================================
'use strict';

import MneTableWeblet from '/weblet/allg/table/filter.mjs'

class MneSbsDns extends MneTableWeblet
{
  constructor(parent, frame, id, initpar = {}, config = {})
  {
    var ivalues =
    {
      css: 'sbs/domain/dns.css',
      whereweblet: '/weblet/sbs/domain/dnstablefilter',
      tableweblet: '/weblet/sbs/domain/dnstable',

      url: 'sysexec/sbs/domain/dns_read',
      addurl: 'sysexec/sbs/domain/dns_add',
      modurl: 'sysexec/sbs/domain/dns_mod',
      delurl: 'sysexec/sbs/domain/dns_del',

      cols: 'name,dns_record,address,fix,mac,comment,readtime,missmatch,nodns',
      primarykey: ['name', 'dns_record', 'address'],
      tablecoltype: { dns_record: 'selection', name: 'text', address: 'text', fix: 'bool', mac: 'text', comment: 'text' },
      tablerowstyle: ['missmatch', 'nodns'],
      tablerowstylecol: ['missmatch', 'nodns'],
      tablehidecols: ['nodns'],

      nomodifyok: true,

      okids: ['name', 'dns_record', 'address'],
      addcols: ['name', 'dns_record', 'address', 'fix', 'mac', 'comment'],
      addtyps: {},

      modcols: ['name', 'dns_record', 'address', 'fix', 'mac', 'comment'],
      modtyps: {},

      delids: ['name', 'dns_record', 'address', 'fix'],
      deltyps: {},
      delconfirmids: ['name', 'dns_record', 'address'],

      defvalues: { name: '', dns_record: 'A', address: '' }
    };

    super(parent, frame, id, Object.assign(ivalues, initpar), config);
  }
}

export default MneSbsDns
