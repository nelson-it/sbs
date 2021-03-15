//================================================================================
//
// Copyright: M.Nelson - technische Informatik
// Die Software darf unter den Bedingungen 
// der APGL ( Affero Gnu Public Licence ) genutzt werden
//
// datei: sbs/user/grouptable.mjs
//================================================================================
'use strict';

import MneConfig    from '/js/basic/config.mjs'
import MneText      from '/js/basic/text.mjs'
import MneLog       from '/js/basic/log.mjs'
import MneRequest   from '/js/basic/request.mjs'
import MneElement from '/weblet/basic/element.mjs'
import MneInput     from '/js/basic/input.mjs'

import MneWeblet from '/weblet/basic/weblet.mjs'
import MneDbView from '/weblet/db/view.mjs'
import MneDbTableView from '/weblet/db/table/view.mjs'
import MneDialog from '/weblet/allg/etc/dialog.mjs'

class MneSbsUserGroupTable extends MneDbTableView
{
  constructor(parent, frame, id, initpar = {}, config = {} )
  {
    var ivalues = 
    {
    };

    super(parent, frame, id, Object.assign(ivalues, initpar), config );
  }
 
  getCssPath()  { return (( super.getCssPath() ) ?  super.getCssPath() + ',' : '') + this.getCss(import.meta.url); }

  reset()
  {
    super.reset();
    this.obj.run.passwd = new MneDialog( this, null, 'dialog', {passwd : true, label : '#mne_lang#Administrator Password' }, { label : '#mne_lang#Bitte Password eingeben', path: '/weblet/allg/etc/dialog' } );
    if ( ! this.initpar.passwdweblet ) this.initpar.passwdweblet = this.parent.id;
  }
  
  async ok()
  {

    var passwdweblet = this.config.composeparent.obj.weblets[this.initpar.passwdweblet];

    if ( ! passwdweblet.obj.run.passval )
    {
        this.obj.run.nowaitframe = true;
        MneElement.mkClass(MneWeblet.waitframe, 'show', false);
        await this.obj.run.passwd.show();
        passwdweblet.obj.run.passval = await this.obj.run.passwd.prompt();
    }
    
    if ( ! passwdweblet.obj.run.passval ) return false;

    var newval = true;
    await this.execute_modified( async () => 
    {
      try { await MneDbView.prototype.ok.call(this, { passwd : passwdweblet.obj.run.passval, cols : this.initpar.cols }); } catch (e) { passwdweblet.obj.run.passval = undefined; newval = false };
    })
    
    this.newvalues = newval;
    
  }
}

export default MneSbsUserGroupTable
