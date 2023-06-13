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
			!body.hasOwnProperty("descripcion") 
			){
				return {
				 estado : false,
				 mensaje :"se requiere de descripcion."
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
	   let descripcion=body.descripcion==null || body.descripcion=="" ? null : body.descripcion;
	   let vigencia=body.vigencia==null || body.vigencia==="" ? null : body.vigencia;
       if(id==null){
		return {
			estado : false,
			mensaje :"EL id es requerido."
		}
	   }	  
       if(descripcion==null){
			return {
				estado : false,
				mensaje :"EL descripcion es requerido ."
			}
		}
		if(descripcion.length>255){
			return {
				estado : false,
				mensaje :"EL descripcion no debe sobrepasar los 255 digitos ."
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
				"@descripcion":descripcion
			}
		}
	  };
	}
}