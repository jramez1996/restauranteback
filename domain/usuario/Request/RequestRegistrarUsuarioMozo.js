var regexValid = require('../../../global/index.js');
module.exports = {
	async esValido(dataReq) {
      body=dataReq.body;
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
			!body.hasOwnProperty("documentoIdentidad")
			){
				return {
				 estado : false,
				 mensaje :"se requiere de documentoIdentidad."
				}
		}
		if(
			!body.hasOwnProperty("usuario")
			){
				return {
				 estado : false,
				 mensaje :"se requiere de usuario."
				}
		}
		console.log("idUbigeo",body.hasOwnProperty("idUbigeo"));
		if(
			!body.hasOwnProperty("idUbigeo")
			){
			return {
				 estado : false,
				 mensaje :"se requiere de idUbigeo."
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
	   let vigencia=body.vigencia==null || body.vigencia==="" ? null : body.vigencia;
	   let nombreCompleto=body.nombreCompleto==null || body.nombreCompleto==="" ? null : body.nombreCompleto.toString();
	   let documentoIdentidad=body.documentoIdentidad==null || body.documentoIdentidad==="" ? null : body.documentoIdentidad.toString();
	   let usuario=body.usuario==null || body.usuario==="" ? null : body.usuario.toString();
	   let reqIdUbigeo=body.idUbigeo==null || body.idUbigeo==="" ? null : body.idUbigeo.toString();
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
		if(documentoIdentidad==null){
			return {
				estado : false,
				mensaje :"EL documentoIdentidad es requerido ."
			}
		}
		if(documentoIdentidad.length>25){
			return {
				estado : false,
				mensaje :"EL documentoIdentidad no debe sobrepasar los 25 digitos ."
			}
		}
		if(usuario==null){
			return {
				estado : false,
				mensaje :"EL usuario es requerido ."
			}
		}
		if(usuario.length>255){
			return {
				estado : false,
				mensaje :"EL usuario no debe sobrepasar los 255 digitos ."
			}
		}
		if(reqIdUbigeo==null){
			return {
				estado : false,
				mensaje :"EL idUbigeo es requerido ."
			}
		}
		
		console.log("reqIdUbigeo.match(regexValid.VALIDENTERO)",regexValid.VALIDENTERO);
		console.log("reqIdUbigeo.match(regexValid.VALIDENTERO)",reqIdUbigeo.match(regexValid.VALIDENTERO));
		if(reqIdUbigeo.match(regexValid.VALIDENTERO)==null){
			return {
				estado : false,
				mensaje :"EL idUbigeo debe ser entero."
			}
		}
		/*
		if(reqIdUbigeo){
			return {
				estado : false,
				mensaje :"EL idUbigeo no debe sobrepasar los 255 digitos ."
			}
		}*/
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
				"@reqIdUbigeo":reqIdUbigeo,
				"@usuario":usuario,
				"@documentoIdentidad":documentoIdentidad,
				"@nombreCompleto":nombreCompleto,
				"@vigencia":vigencia ? 1 : 0
			}
		}
	  };
	}
}