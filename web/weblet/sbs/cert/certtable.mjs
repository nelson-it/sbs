//================================================================================
//
// Copyright: M.Nelson - technische Informatik
// Die Software darf unter den Bedingungen 
// der APGL ( Affero Gnu Public Licence ) genutzt werden
//
// datei: sbs/cert/certtable.mjs
//================================================================================
'use strict';

import MneConfig from '/js/basic/config.mjs'
import MneText from '/js/basic/text.mjs'
import MneLog from '/js/basic/log.mjs'
import MneRequest from '/js/basic/request.mjs'
import MneElement from '/weblet/basic/element.mjs'
import MneInput from '/js/basic/input.mjs'

import MneWeblet from '/weblet/basic/weblet.mjs'
import MneDbView from '/weblet/db/view.mjs'
import MneDbTableView from '/weblet/db/table/view.mjs'
import MneDialog from '/weblet/allg/etc/dialog.mjs'

class MneSbsCertCertTable extends MneDbTableView
{
  reset()
  {
    super.reset();

    this.obj.mkbuttons.push({ id: 'download', value: MneText.getText('#mne_lang#Download'), behind: 'refresh' });

    this.obj.enablebuttons.buttons.push('download');
    this.obj.enablebuttons.select.push('download');

    this.obj.run.passwd = new MneDialog(this, null, 'dialog', { passwd: true, label: '#mne_lang#CA Password' }, { label: '#mne_lang#Bitte CA Password eingeben', path: '/weblet/allg/etc/dialog' });
    this.obj.run.passwdvalue = null;
  }

  async mkRow(r)
  {
    var row = r;
    
    await super.mkRow(row);

    if (row.obj.files.filename)
    {
      row.obj.files.filename.addEventListener('change', (evt) =>
      {
        if (evt.target.files[0].size > 5000000)
        {
          MneLog.error(MneText.getText('#mne_lang#Datei ist grösser als 5MB'));
          row.obj.outputs.data.modValue('');
          return;
        }

        var reader = new FileReader();
        reader.addEventListener('load', (evt) =>
        {
          row.obj.outputs.data.modValue(evt.target.result.split(',')[1]);
        });
        reader.readAsDataURL(evt.target.files[0]);
      }, true);
    }

  }

  async ok()
  {
    var needpasswd = false;
    var passwd = '';

    if (this.obj.run.passwdvalue == null )
    {
      await this.execute_modified(() => 
      {
        needpasswd = needpasswd || (this.obj.inputs.filename.getModify() || this.obj.outputs.data.getModify() || this.obj.run.okaction == 'add')
      })

      if (needpasswd)
      {
        this.obj.run.nowaitframe = true;
        MneElement.mkClass(MneWeblet.waitframe, 'show', false);
        await this.obj.run.passwd.show();
        this.obj.run.passwdvalue = await this.obj.run.passwd.prompt();
      }
    }

    if (this.obj.run.passwdvalue == null) return false;

    var newval = true;
    await this.execute_modified(async () => 
    {
      try { await MneDbView.prototype.ok.call(this, { passwd: this.obj.run.passwdvalue }); } catch (e) { newval = false };
    })

    if ( ! newval ) this.obj.run.passwdvalue = null;
    this.newvalues = newval;
  }

  async download()
  {
    await this.execute_selected(() =>
    {
      var hiddenElement = document.createElement('a');

      hiddenElement.href = 'sysexec/sbs/cert/cert_download/' + this.obj.run.values.filename + "?dirInput.old=" + this.initpar.showalias[0]();
      hiddenElement.target = '_blank';
      hiddenElement.click();
    });

    return false;
  }

  async dblclick()
  {
    return this.download();
  }
}

export default MneSbsCertCertTable
