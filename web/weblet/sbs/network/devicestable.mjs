//================================================================================
//
// Copyright: M.Nelson - technische Informatik
// Die Software darf unter den Bedingungen 
// der APGL ( Affero Gnu Public Licence ) genutzt werden
//
// datei: sbs/network/devicestable.mjs
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

class MneSbsNetworkDevicestable extends MneDbTableView
{
  async ok()
  {
    await this.execute_selected( () => { MneDbView.prototype.ok.call(this) } );
    this.dependweblet = this;
  }

}

export default MneSbsNetworkDevicestable
