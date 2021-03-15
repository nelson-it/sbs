//================================================================================
//
// Copyright: M.Nelson - technische Informatik
// Die Software darf unter den Bedingungen 
// der APGL ( Affero Gnu Public Licence ) genutzt werden
//
// datei: sbs/domain/detail.mjs
//================================================================================
'use strict';

import MneConfig   from '/js/basic/config.mjs'
import MneText     from '/js/basic/text.mjs'
import MneInput    from '/js/basic/input.mjs'
import MneLog      from '/js/basic/log.mjs'
import MneRequest  from '/js/basic/request.mjs'

import MneElement from '/weblet/basic/element.mjs'
import MneDbView  from '/weblet/db/view.mjs'

class MneTemplate extends MneDbView
{
  constructor(parent, frame, id, initpar = {}, config = {} )
  {
    var ivalues = 
    {
      url    : 'sysexec/sbs/domain/detail_read',
      modurl : 'sysexec/sbs/domain/detail_mod',
      
      readparurl : 'sysexec/sbs/domain/detailnet_mod',
      
      hinput : false
    };

    super(parent, frame, id, Object.assign(ivalues, initpar), config );
  }

  getViewPath() { return this.getView(import.meta.url) }
  getCssPath()  { return (( super.getCssPath() ) ?  super.getCssPath() + ',' : '') + this.getCss(import.meta.url); }
  
  reset()
  {
    super.reset();
    this.obj.mkbuttons.push( { id : 'netpar', value : MneText.getText('#mne_lang#Netzwerk übernehmen') } );
    
    this.obj.run.netparpar = {};
    
    this.obj.run.btnrequest.netpar = this.initpar.readparurl;
  }
  
  getParamNetpar(p)
  {
      "domaintyp,domain,workgroup,description,netdevice,dnsforwarder,dnssearch,dhcpstart,dhcpend,dhcp6start,dhcp6end".split(',').forEach( ( item) =>
      {
        p = this.addParam(p, item + "Input", this.obj.inputs[item]);
      });
      
      return p;
  }

  async load()
  {
    await super.load();
    this.obj.inputs.domaintyp.addEventListener('change', (evt) =>
    {
      MneElement.mkClass(this.frame, 'domaintyp' + this.obj.inputs.domaintyp.getValue(), true,  'domaintyp');
      var passwd = ( this.obj.inputs.domaintyp.getValue() == 'standalone' ) ? 'dummy' : '';
      this.obj.inputs.adminpassword.setValue(passwd);
      this.obj.inputs.adminpassword2.setValue(passwd);
    });
    this.obj.inputs.adminpassword.addEventListener('input', (evt) => {  this.checkpasswd() } );

    this.obj.observer.adminpassword2 = new MutationObserver((mut) => { this.checkpasswd(); });
    this.obj.observer.adminpassword2.observe(this.obj.inputs.adminpassword2, { childList: false, subtree: false, attributeOldValue: true, attributes : true, attributeFilter: [ 'newvalue' ] } );
  }

  checkpasswd()
  {
    if ( this.obj.inputs.domaintyp.getValue() == 'primary' || this.obj.inputs.domaintyp.getValue() == 'second' )
    {
      MneElement.mkClass(this.obj.inputs.adminpassword2.parentNode, 'modify' + (( this.obj.inputs.adminpassword.getValue(false) != this.obj.inputs.adminpassword2.getValue(false) ) ? 'wrong' : (( this.obj.inputs.adminpassword2.getAttribute('newvalue') != this.obj.inputs.adminpassword2.getAttribute('oldvalue') ) ? 'ok' : 'no' )), true, 'modify' );
    }
  }
  
  async netpar()
  {
    this.obj.run.okaction = 'netpar';
    return super.ok();
  }
  
  async ok()
  {
    if ( this.confirm(MneText.sprintf( MneText.getText("#mne_lang#Domaindaten wirklich ändern? Alle Domaindaten ins besondere die Benutzer und deren Passwörter werden gelöscht")) ))
        return super.ok()
    return false;
  }
  
  async values()
  {
    await super.values();
    MneElement.mkClass(this.frame, 'domaintyp' + this.obj.run.values.domaintyp, true,  'domaintyp');
  }

}

export default MneTemplate;
