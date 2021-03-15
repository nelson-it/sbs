//================================================================================
//
// Copyright: M.Nelson - technische Informatik
// Die Software darf unter den Bedingungen 
// der APGL ( Affero Gnu Public Licence ) genutzt werden
//
// datei: sbs/cert/certtable.mjs
//================================================================================
'use strict';

import MneConfig    from '/js/basic/config.mjs'
import MneText      from '/js/basic/text.mjs'
import MneLog       from '/js/basic/log.mjs'
import MneRequest   from '/js/basic/request.mjs'
import MneElement from '/weblet/basic/element.mjs'
import MneInput     from '/js/basic/input.mjs'

import MneDbView from '/weblet/db/view.mjs'
import MneDbTableView from '/weblet/db/table/view.mjs'

class MneSbsCertCertTable extends MneDbTableView
{
  reset()
  {
    super.reset();
    
    this.obj.mkbuttons.push( { id : 'download', value : MneText.getText('#mne_lang#Download'), behind : 'refresh' } );
    
    this.obj.enablebuttons.buttons.push('download');
    this.obj.enablebuttons.select.push('download');
  }
  
  async mkRow(row)
  {
    await super.mkRow(row);
    
    if ( row.obj.files.filename )
    {
      row.obj.files.filename.addEventListener('change', (evt) =>
      {
        if ( evt.target.files[0].size > 5000000 )
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

  async download()
  {
    await this.execute_selected( () => {
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
