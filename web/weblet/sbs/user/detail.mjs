//================================================================================
//
// Copyright: M.Nelson - technische Informatik
// Die Software darf unter den Bedingungen 
// der APGL ( Affero Gnu Public Licence ) genutzt werden
//
// datei: sbs/user/detail.mjs
//================================================================================
'use strict';

import MneConfig   from '/js/basic/config.mjs'
import MneText     from '/js/basic/text.mjs'
import MneInput    from '/js/basic/input.mjs'
import MneLog      from '/js/basic/log.mjs'
import MneRequest  from '/js/basic/request.mjs'

import MneWeblet  from '/weblet/basic/weblet.mjs'
import MneElement from '/weblet/basic/element.mjs'
import MneDbView  from '/weblet/db/view.mjs'
import MneDialog  from '/weblet/allg/etc/dialog.mjs'

class MneSbsUserDetail extends MneDbView
{
  constructor(parent, frame, id, initpar = {}, config = {} )
  {
    var ivalues = 
    {
      url           : 'sysexec/sbs/user/detail_read',
      showids       : ['sAMAccountName'],
      
      addurl        : 'sysexec/sbs/user/detail_add',
      modurl        : 'sysexec/sbs/user/detail_mod',
      delurl        : 'sysexec/sbs/user/detail_del',
      
      delconfirmids : [ 'sAMAccountName'],

      selectlists   : { preferredLanguage : 'language' },
      defvalues     : { sAMAccountName : '' },
      
      hinput : false
    };

    super(parent, frame, id, Object.assign(ivalues, initpar), config );
  }

  getViewPath() { return this.getView(import.meta.url) }
  //getCssPath()  { return (( super.getCssPath() ) ?  super.getCssPath() + ',' : '') + this.getCss(import.meta.url); }

  reset()
  {
    super.reset();
    this.obj.run.passwd = new MneDialog( this, null, 'dialog', {passwd : true, label : '#mne_lang#Administrator Password' }, { label : '#mne_lang#Bitte Password eingeben', path: '/weblet/allg/etc/dialog' } );
  }

  async add(data)
  {
    if ( ! data.nomod && this.getModify() )
      this.obj.defvalues.sAMAccountName = this.obj.inputs.sAMAccountName.getValue();

    try { await super.add(data) } catch (e) { this.obj.defvalues.sAMAccountName; throw e };

    this.obj.defvalues.sAMAccountName = ''; 
  }
  
  async ok()
  {
    var cols,i;
    
    if ( ! this.obj.run.passval )
    {
        this.obj.run.nowaitframe = true;
        MneElement.mkClass(MneWeblet.waitframe, 'show', false);
        await this.obj.run.passwd.show();
        this.obj.run.passval = await this.obj.run.passwd.prompt();
    }
    
    cols='';
    for ( i in this.obj.inputs )
      if ( ! this.obj.inputs[i].noautoread ) cols += i + ",";
    cols = cols.substring(0,cols.length - 1);

    if ( this.obj.run.passval )
      try { await super.ok({ passwd : this.obj.run.passval, cols : cols }); } catch (e) { this.obj.run.passval = ""; throw e };
    
    this.obj.run.values.sAMAccountName = this.obj.inputs.sAMAccountName.getValue(false);
  }


}

export default MneSbsUserDetail;
