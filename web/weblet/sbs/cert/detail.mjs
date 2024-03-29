//================================================================================
//
// Copyright: M.Nelson - technische Informatik
// Die Software darf unter den Bedingungen 
// der APGL ( Affero Gnu Public Licence ) genutzt werden
//
// datei: sbs/cert/detail.mjs
//================================================================================
'use strict';

import MneConfig from '/js/basic/config.mjs'
import MneText from '/js/basic/text.mjs'
import MneInput from '/js/basic/input.mjs'
import MneLog from '/js/basic/log.mjs'
import MneRequest from '/js/basic/request.mjs'

import MneElement from '/weblet/basic/element.mjs'
import MneDbView from '/weblet/db/view.mjs'

class MneSbsCertDetail extends MneDbView
{
  constructor(parent, frame, id, initpar = {}, config = {})
  {
    var ivalues =
    {
      url: 'sysexec/sbs/cert/detail_read',

      placeholder: {
        country: MneText.getText("#mne_lang#Mein Land"),
        state: MneText.getText("#mne_lang#Meine Region"),
        city: MneText.getText("#mne_lang#Meine Stadt"),
        org: MneText.getText("#mne_lang#Meine Firma#"),
        orgunit: MneText.getText("#mne_lang#Meine Abteilung#"),
        email: MneText.getText("#mne_lang#email@meine.domain")
      },

      modurl: 'sysexec/sbs/cert/detail_ok',
      modcols: ['country', 'state', 'city', 'org', 'orgunit', 'email', 'passwd', 'overwrite'],

      title: { mod: config.label },
      regexp: { country: { reg: new RegExp('[A-Z][A-Z]'), help: MneText.getText("#mne_lang#Bitte 2 stelliges Landeskenzeichen eingeben") } },
      hinput: false
    };

    super(parent, frame, id, Object.assign(ivalues, initpar), config);
  }

  getViewPath() { return this.getView(import.meta.url) }
  //getCssPath()  { return (( super.getCssPath() ) ?  super.getCssPath() + ',' : '') + this.getCss(import.meta.url); }

  reset()
  {
    super.reset();
    this.obj.mkbuttons.push({ id: 'download', value: MneText.getText('#mne_lang#Download CA') });
  }

  async load()
  {
    await super.load();
    this.obj.files.cafile.addEventListener('change', (evt) =>
    {
      if (evt.target.files[0].size > 5000000)
      {
        MneLog.error(MneText.getText('#mne_lang#Datei ist grösser als 5MB'));
        this.obj.inputs.ca.modValue('');
        return;
      }

      var reader = new FileReader();
      reader.addEventListener('load', (evt) =>
      {
        this.obj.inputs.ca.modValue(evt.target.result.split(',')[1]);
        this.obj.inputs.country.modValue('OK')
      });
      reader.readAsDataURL(evt.target.files[0]);
    }, true);

    this.obj.files.keyfile.addEventListener('change', (evt) =>
    {
      if (evt.target.files[0].size > 5000000)
      {
        MneLog.error(MneText.getText('#mne_lang#Datei ist grösser als 5MB'));
        this.obj.inputs.key.modValue('');
        return;
      }

      var reader = new FileReader();
      reader.addEventListener('load', (evt) =>
      {
        this.obj.inputs.key.modValue(evt.target.result.split(',')[1]);
        this.obj.inputs.country.modValue('OK')
      });
      reader.readAsDataURL(evt.target.files[0]);
    }, true);
  }


  async download()
  {
    var hiddenElement = document.createElement('a');

    hiddenElement.href = 'sysexec/sbs/cert/cert_download/ca.crt?dirInput.old=ca';
    hiddenElement.target = '_blank';
    hiddenElement.click();

    return false;
  }
}

export default MneSbsCertDetail;
