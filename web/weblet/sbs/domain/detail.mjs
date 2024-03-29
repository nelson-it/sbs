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

class MneSbsDomain extends MneDbView
{
  constructor(parent, frame, id, initpar = {}, config = {} )
  {
    var ivalues = 
    {
      url    : 'sysexec/sbs/domain/detail_read',
      modurl : 'sysexec/sbs/domain/detail_mod',
      
      netparurl : 'sysexec/sbs/domain/detailnet_mod',
      primaryurl : 'sysexec/sbs/domain/detailprimary_mod',
      demoteurl : 'sysexec/sbs/domain/detaildemote_mod',
      
      hinput : false
    };

    super(parent, frame, id, Object.assign(ivalues, initpar), config );
  }

  getViewPath() { return this.getView(import.meta.url) }
  getCssPath()  { return (( super.getCssPath() ) ?  super.getCssPath() + ',' : '') + this.getCss(import.meta.url); }
  
  reset()
  {
    super.reset();
    this.delbutton('ok');
    
    this.obj.mkbuttons.push( { id : 'domain', value : MneText.getText('#mne_lang#Domain Ok'), before : 'cancel' } );
    this.obj.mkbuttons.push( { id : 'netpar', value : MneText.getText('#mne_lang#Netzwerk übernehmen'), space : 'before' } );
    this.obj.mkbuttons.push( { id : 'primary', value : MneText.getText('#mne_lang#Primär') } );
    this.obj.mkbuttons.push( { id : 'demote', value : MneText.getText('#mne_lang#Controller entfernen'), space : 'before' } );
    
    this.obj.run.netparpar = {};
    
    this.obj.run.btnrequest.netpar = this.initpar.netparurl;
    this.obj.run.btnrequest.primary = this.initpar.primaryurl;
    this.obj.run.btnrequest.demote = this.initpar.demoteurl;
  }
  
  getParamNetpar(p)
  {
      "domaintyp,domain,workgroup,description,netdevice,dnsforwarder,dnssearch,dhcpstart,dhcpend,dhcp6start,dhcp6end".split(',').forEach( ( item) =>
      {
        p = this.addParam(p, item + "Input", this.obj.inputs[item]);
      });
      
      return p;
  }
  
 getParamPrimary(p)
  {
      "administrator,adminpassword,adminpassword2".split(',').forEach( ( item) =>
      {
        p = this.addParam(p, item + "Input", this.obj.inputs[item]);
      });
      
      return p;
  }

  getParamDemote(p)
  {
      "administrator,adminpassword,adminpassword2".split(',').forEach( ( item) =>
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
      if ( this.obj.inputs.domaintyp.getValue() == 'standalone' || this.obj.inputs.domaintyp.getValue() == '' )
      {
        var p = this.obj.inputs.adminpassword
        p.setTyp(p.dpytype, MneInput.checktype['ok'], p.format)
        p = this.obj.inputs.netdevice
        p.setTyp(p.dpytype, MneInput.checktype['ok'], p.format)
        p = this.obj.inputs.domain
        p.setTyp(p.dpytype, MneInput.checktype['ok'], p.format)
      }
      else
      {
        var p = this.obj.inputs.adminpassword
        p.setTyp(p.dpytype, MneInput.checktype['notempty'], p.format)
        p = this.obj.inputs.netdevice
        p.setTyp(p.dpytype, MneInput.checktype['notempty'], p.format)
        p = this.obj.inputs.domain
        p.setTyp(p.dpytype, MneInput.checktype['notempty'], p.format)
      }
      var passwd = '';
      this.obj.inputs.adminpassword.setValue(passwd);
      this.obj.inputs.adminpassword2.setValue(passwd);
      this.obj.inputs.netdevice.setValue(passwd);
      this.obj.inputs.domain.setValue(passwd);
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
  
  async primary()
  {
    this.obj.run.okaction = 'primary';
    if ( this.confirm(MneText.sprintf( MneText.getText("#mne_lang#wirklich zum Primary Controller ändern?")) ))
      return super.ok();
    return false;
  }

  async demote()
  {
    this.obj.run.okaction = 'demote';
    if ( this.confirm(MneText.sprintf( MneText.getText("#mne_lang#wirklich Controller entfernen?")) ))
      return super.ok();
    return false;
  }
  
  async ok()
  {
    return false;
  }
  
  async domain()
  {
    this.obj.run.okaction = 'mod';
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

export default MneSbsDomain;
