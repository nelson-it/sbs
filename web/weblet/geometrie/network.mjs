//================================================================================
//
// Copyright: M.Nelson - technische Informatik
// Die Software darf unter den Bedingungen 
// der APGL ( Affero Gnu Public Licence ) genutzt werden
//
// datei: geometrie/network.mjs
//================================================================================
'use strict';
import { MneVSlider, MneHSlider }  from '/js/geometrie/slider.mjs'
import MneElement from '/weblet/basic/element.mjs'

class MneTemplateHH
{
  static mkTemplate( weblet )
  {
    weblet.obj.container = {};
    weblet.obj.slider = {};

    var s0 = weblet.obj.slider.slider0 = new MneHSlider(weblet.frame, '40%', 'move');
    var s1 = weblet.obj.slider.slider1 = new MneVSlider(s0.container0, '60%', 'move');

    weblet.obj.container['addresses']= s1.container0
    weblet.obj.container['network']  = s1.container1
    weblet.obj.container['devices']  = s0.container1

  }
}

export default MneTemplateHH
