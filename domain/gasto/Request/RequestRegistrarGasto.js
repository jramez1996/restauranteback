var regexValid = require('../../../global/index.js');
module.exports = {
	async esValido(dataReq) {
      body=dataReq.body;
	  if(
			!body.hasOwnProperty("descripcion") 
			){
				return {
				 estado : false,
				 mensaje :"se requiere de descripcion."
				}
		}	
		if(
			!body.hasOwnProperty("idTipoGasto")
			){
				return {
				 estado : false,
				 mensaje :"se requiere de idTipoGasto."
				}
	   }
	   if(
		!body.hasOwnProperty("costo")
		){
			return {
			 estado : false,
			 mensaje :"se requiere de costo."
			}
	   }
	   let descripcion=body.descripcion==null || body.descripcion=="" ? null : body.descripcion.toString();
	   let idTipoGasto=body.idTipoGasto==null || body.idTipoGasto=="" ? null : body.idTipoGasto.toString();
	   let costo=body.costo==null || body.costo=="" ? null : body.costo;
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
	   if(idTipoGasto.match(regexValid.VALIDENTERO)==null){
			return {
				estado : false,
				mensaje :"EL idTipoGasto debe ser entero."
			}
	   }
	   if(costo==null){
		return {
			estado : false,
			mensaje :"EL precio es requerida ."
		}
	   }
	   if( isNaN(Number(costo)) ){
			return {
				estado : false,
				mensaje :"EL costo debe ser decimal."
			}
	   } 
	   return {
		estado:true,
		data:{
			dataFormat:{
				"@descripcion":descripcion,
				"@idtipogasto":idTipoGasto,
				"@costo":costo
			}
		}
	  };
	}
}