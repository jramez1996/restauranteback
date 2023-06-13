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
		if(
			!body.hasOwnProperty("precio")
			){
				return {
				 estado : false,
				 mensaje :"se requiere de precio."
				}
	   }
	   if(
		!body.hasOwnProperty("idUnidadMedida")
		){
			return {
			 estado : false,
			 mensaje :"se requiere de idUnidadMedida."
			}
   	   }			
	   let nombre=body.nombre==null || body.nombre=="" ? null : body.nombre.toString();
	   let vigencia=body.vigencia==null || body.vigencia==="" ? null : body.vigencia;
       let precio=body.precio==null || body.precio=="" ? null : body.precio.toString();
       let idUnidadMedida=body.idUnidadMedida==null || body.idUnidadMedida=="" ? null : body.idUnidadMedida.toString();
	   
	   if(idUnidadMedida==null){
		return {
			estado : false,
			mensaje :"EL idUnidadMedida es requerido ."
		}
	   }
	   if(idUnidadMedida.match(regexValid.VALIDENTERO)==null){
		return {
			estado : false,
			mensaje :"EL idUnidadMedida debe ser entero."
		}
	   } 	 
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
		if(precio==null){
			return {
				estado : false,
				mensaje :"EL precio es requerido ."
			}
		   }
		   if( isNaN(Number(precio)) ){
			return {
				estado : false,
				mensaje :"EL precio debe ser decimal."
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
				"@precio":precio,
				"@idUnidadMedida":idUnidadMedida,
				"@vigencia":vigencia ? 1 : 0
			}
		}
	  };
	}
}