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
			!body.hasOwnProperty("nombreCompleto") 
			){
				return {
				 estado : false,
				 mensaje :"se requiere de nombreCompleto."
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
			!body.hasOwnProperty("idUbigeo")
			){
			return {
				 estado : false,
				 mensaje :"se requiere de idUbigeo."
			}
	   }
	   let idMozo=body.id==null || body.id==="" ? null : body.id.toString();
	   let vigencia=body.vigencia==null || body.vigencia==="" ? null : body.vigencia;
	   let nombreCompleto=body.nombreCompleto==null || body.nombreCompleto==="" ? null : body.nombreCompleto.toString();
	   let reqIdUbigeo=body.idUbigeo==null || body.idUbigeo==="" ? null : body.idUbigeo.toString();
       if(idMozo==null){
			return {
				estado : false,
				mensaje :"EL id es requerido ."
			}
		}
		if(nombreCompleto==null){
			return {
				estado : false,
				mensaje :"EL nombreCompleto es requerido ."
			}
		}
		if(nombreCompleto.length>500){
			return {
				estado : false,
				mensaje :"EL nombreCompleto no debe sobrepasar los 500 digitos ."
			}
		}
		
		if(reqIdUbigeo==null){
			return {
				estado : false,
				mensaje :"EL reqIdUbigeo es requerido ."
			}
		}
		if(idMozo.match(regexValid.VALIDENTERO)==null){
			return {
				estado : false,
				mensaje :"EL id debe ser entero."
			}
		}
		if(reqIdUbigeo.match(regexValid.VALIDENTERO)==null){
			return {
				estado : false,
				mensaje :"EL reqIdUbigeo debe ser entero."
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
				"@idMozo":idMozo,
				"@nombreCompleto":nombreCompleto,
				"@reqIdUbigeo":reqIdUbigeo,
				"@vigencia":vigencia ? 1 : 0
			}
		}
	  };
	}
}