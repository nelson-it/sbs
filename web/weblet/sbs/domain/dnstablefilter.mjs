//================================================================================
//
// Copyright: M.Nelson - technische Informatik
// Die Software darf unter den Bedingungen 
// der APGL ( Affero Gnu Public Licence ) genutzt werden
//
// datei: sbs/network/devices.mjs
//================================================================================
'use strict';

import MneRequest   from '/js/basic/request.mjs'
import MneWhereSelect from '/weblet/allg/table/where/single.mjs'

class MneWhereDnsSelect extends MneWhereSelect
{
  constructor(parent, frame, id, initpar = {}, config = {} )
  {
    var ivalues = 
    {
      selcol : 'name'
    };
    
    super(parent, frame, id, Object.assign(ivalues, initpar), config );
  }
  
    getViewPath() { return this.getView(import.meta.url) }
    
    async values()
    {
      var p =
      {
        cols : "typ,name,addr",   
        wcol : 'typ',
        wop  : '=',
        wval : 'forward'
      }
      var res = await MneRequest.fetch('sysexec/sbs/domain/dnszone_read', p);
      
      var str = '';
      res.values.forEach(item => str += '<option value="' + item[1] + '">' + item[1] + '</option>');
      
      this.obj.inputs.domain.innerHTML = str;
      this.obj.inputs.domain.setValue(res.values[0][1])
      console.log(res)
    }
    

}

export default MneWhereDnsSelect
