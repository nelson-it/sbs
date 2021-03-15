//================================================================================
//
// Copyright: M.Nelson - technische Informatik
// Die Software darf unter den Bedingungen 
// der APGL ( Affero Gnu Public Licence ) genutzt werden
//
// datei: sbs/apache/sitetable.mjs
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

class MneSbsApacheSiteTable extends MneDbTableView
{
  
  getCssPath()  { return (( super.getCssPath() ) ?  super.getCssPath() + ',' : '') + this.getCss(import.meta.url); }

  reset()
  {
    super.reset();
    this.obj.run.passwd = new MneDialog( this, null, 'dialog', {passwd : true, label : '#mne_lang#CA Password' }, { label : '#mne_lang#Bitte CA Password eingeben', path: '/weblet/allg/etc/dialog' } );
  }
  
  async ok()
  {
    var needpasswd = false;
    var passwd = '';
    
    await this.execute_modified( () => 
    {
      this.obj.inputs.renewcert.modValue(( this.obj.inputs.domain.getModify() || this.obj.inputs.aliases.getModify() || this.obj.inputs.renewcert.getValue() || this.obj.run.okaction == 'add' ))
      needpasswd = needpasswd || this.obj.inputs.renewcert.getValue();
    })

    if ( needpasswd )
    {
        this.obj.run.nowaitframe = true;
        MneElement.mkClass(MneWeblet.waitframe, 'show', false);
        await this.obj.run.passwd.show();
        passwd = await this.obj.run.passwd.prompt();
    }
    
    if ( passwd == null ) return false;
    
    var newval = true;
    await this.execute_modified( async () => 
    {
      try { await MneDbView.prototype.ok.call(this, { passwd : passwd }); } catch (e) { newval = false };
    })
    
    this.newvalues = newval;
    
  }
}

export default MneSbsApacheSiteTable
