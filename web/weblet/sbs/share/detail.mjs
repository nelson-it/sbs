//================================================================================
//
// Copyright: M.Nelson - technische Informatik
// Die Software darf unter den Bedingungen 
// der APGL ( Affero Gnu Public Licence ) genutzt werden
//
// datei: weblet/templ/templ.mjs
//================================================================================
'use strict';

import MneConfig   from '/js/basic/config.mjs'
import MneText     from '/js/basic/text.mjs'
import MneInput    from '/js/basic/input.mjs'
import MneLog      from '/js/basic/log.mjs'
import MneRequest  from '/js/basic/request.mjs'

import MneElement from '/weblet/basic/element.mjs'
import MneDbView  from '/weblet/db/view.mjs'

class MneSbsShareDetail extends MneDbView
{
  constructor(parent, frame, id, initpar = {}, config = {} )
  {
    var ivalues = 
    {
      url    : 'sysexec/sbs/share/detail_read',
      addurl : 'sysexec/sbs/share/detail_ok',
      modurl : 'sysexec/sbs/share/detail_ok',
      delurl : 'sysexec/sbs/share/detail_ok',

      showids       : ['share'],
      delconfirmids : [ 'share'],
      
      defvalues     : { share : '' },

      hinput : false
    };

    super(parent, frame, id, Object.assign(ivalues, initpar), config );
  }

  getViewPath() { return this.getView(import.meta.url) }
  //getCssPath()  { return (( super.getCssPath() ) ?  super.getCssPath() + ',' : '') + this.getCss(import.meta.url); }

  async ok()
  {
    this.obj.run.values.share = this.obj.inputs.share.getValue();
    return super.ok()
  }
}

export default MneSbsShareDetail;
