//================================================================================
//
// Copyright: M.Nelson - technische Informatik
// Die Software darf unter den Bedingungen 
// der APGL ( Affero Gnu Public Licence ) genutzt werden
//
// datei: sbs/user/passwd.mjs
//================================================================================
'use strict';

import MneConfig   from '/js/basic/config.mjs'
import MneText     from '/js/basic/text.mjs'
import MneLog      from '/js/basic/log.mjs'
import MneTheme    from '/js/basic/theme.mjs'
import MneElement  from '/js/basic/element.mjs'

import MneDbConfig from '/js/db/config.mjs'


import MneDbView   from '/weblet/db/view.mjs'

class MneSbsUserPasswd extends MneDbView
{
    constructor(parent, frame, id, initpar = {}, config = {} )
    {
      var ivalues = 
      {
        url : 'sysexec/sbs/user/passwd_read',
        showids : ['sAMAccountName'],
        
        delbutton  : 'add,del', 

        modurl  : 'sysexec/sbs/user/passwd_mod',
        modcols : ['sAMAccountName', 'password'],

        hinput : false
      };
           
      super(parent, frame, id, Object.assign(ivalues, initpar), config );
    }
    
    getViewPath() { return this.getView(import.meta.url) }

    async load()
    {
         await super.load();
         this.obj.inputs.password.addEventListener('input', (evt) => {  this.checkpasswd() } );

         this.obj.observer.password2 = new MutationObserver((mut) => { this.checkpasswd(); });
         this.obj.observer.password2.observe(this.obj.inputs.password2, { childList: false, subtree: false, attributeOldValue: true, attributes : true, attributeFilter: [ 'newvalue' ] } );

    }
    
    checkpasswd()
    {
        MneElement.mkClass(this.obj.inputs.password2.parentNode, 'modify' + (( this.obj.inputs.password.getValue(false) != this.obj.inputs.password2.getValue(false) ) ? 'wrong' : (( this.obj.inputs.password2.getAttribute('newvalue') != this.obj.inputs.password2.getAttribute('oldvalue') ) ? 'ok' : 'no' )), true, 'modify' );
    }

}

export default MneSbsUserPasswd;
