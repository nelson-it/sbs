//================================================================================
//
// Copyright: M.Nelson - technische Informatik
// Die Software darf unter den Bedingungen 
// der APGL ( Affero Gnu Public Licence ) genutzt werden
//
// datei: sbs/network/devicestable.mjs
//================================================================================
'use strict';

import MneDbTableView from '/weblet/db/table/view.mjs'

class MneSbsDnsTable extends MneDbTableView
{

  getTableParamAdd (p)
  {
    var domain = this.parent.obj.weblets.where.obj.inputs.domain;
    var p = super.getTableParamAdd(p);
    
    p.domainInput = domain.getValue();
    
    return p;
  }

  getTableParamMod (p)
  {
    var domain = this.parent.obj.weblets.where.obj.inputs.domain;
    var p = super.getTableParamMod(p);
    
    p.domainInput = domain.getValue();
    
    return p;
  }

  getTableParamDel (p)
  {
    var domain = this.parent.obj.weblets.where.obj.inputs.domain;
    var p = super.getTableParamDel(p);
    
    p.domainInput = domain.getValue();
    
    return p;
  }

  getParamShow (p, showids, showops)
  {
    var domain = this.parent.obj.weblets.where.obj.inputs.domain;
    var p = super.getParamShow(p, showids, showops);
    
    p.domainInput = domain.getValue();
    
    return p;
  }
}

export default MneSbsDnsTable
