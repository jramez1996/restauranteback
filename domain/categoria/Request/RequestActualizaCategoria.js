var regexValid = require('../../../global/index.js');
module.exports = {
	async esValido(dataReq) {
      body=dataReq.body;
	  if(
		!body.hasOwnProperty("id") 
		){
			return {
			 estado : false,
			 mensaje :"se requiere de id."
			}
	  }
	  if(
			!body.hasOwnProperty("nombre") 
			){
				return {
				 estado : false,
				 mensaje :"se requiere de nombre."
				}
		}	
		if(
			!body.hasOwnProperty("vigencia")
			){
				return {
				 estado : false,
				 mensaje :"se requiere de vigencia."
				}
		}			
	   let id=body.id==null || body.id=="" ? null : body.id.toString();
	   let nombre=body.nombre==null || body.nombre=="" ? null : body.nombre;
	   let vigencia=body.vigencia==null || body.vigencia==="" ? null : body.vigencia;
       if(id==null){
		return {
			estado : false,
			mensaje :"EL id es requerido."
		}
	   }	  
       if(nombre==null){
			return {
				estado : false,
				mensaje :"EL nombre es requerido ."
			}
		}
		if(nombre.length>45){
			return {
				estado : false,
				mensaje :"EL nombre no debe sobrepasar los 45 digitos ."
			}
		}

		if(id.match(regexValid.VALIDENTERO)==null){
			return {
				estado : false,
				mensaje :"EL numero debe ser entero."
			}
		}
		if(!(typeof  vigencia ===  "boolean")){
			return {
				estado : false,
				mensaje :"EL vigencia debe ser boolean."
			}
		}

	   return {
		estado:true,
		data:{
			dataFormat:{
				"@id":id,
				"@vigencia":vigencia ? 1 : 0,
				"@nombre":nombre
			}
		}
	  };
	}
}