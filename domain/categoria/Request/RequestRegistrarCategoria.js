var regexValid = require('../../../global/index.js');
module.exports = {
	async esValido(dataReq) {
      body=dataReq.body;
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
	   let nombre=body.nombre==null || body.nombre=="" ? null : body.nombre;
	   let vigencia=body.vigencia==null || body.vigencia=="" ? null : body.vigencia;
       
       if(nombre==null){
			return {
				estado : false,
				mensaje :"EL nombre es requerido ."
			}
		}
		if(nombre.length>255){
			return {
				estado : false,
				mensaje :"EL nombre no debe sobrepasar los 255 digitos ."
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
				"@nombre":nombre,
				"@vigencia":vigencia ? 1 : 0
			}
		}
	  };
	}
}