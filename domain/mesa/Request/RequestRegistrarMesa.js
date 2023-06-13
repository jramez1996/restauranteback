var regexValid = require('../../../global/index.js');
module.exports = {
	async esValido(dataReq) {
      body=dataReq.body;
		if(
			!body.hasOwnProperty("numero") 
			){
				return {
				 estado : false,
				 mensaje :"se requiere de numero."
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
			!body.hasOwnProperty("idPiso")
			){
				return {
				 estado : false,
				 mensaje :"se requiere de idPiso."
				}
		}	
	   //@reqnumero, @reqestado, @reqidpiso, @reqvigencia)
	   let numero=body.numero==null || body.numero=="" ? null : body.numero.toString();
	   let estado=null;
	   let idPiso=body.idPiso==null || body.idPiso=="" ? null : body.idPiso.toString();
	   let vigencia=body.vigencia==null || body.vigencia==="" ? null : body.vigencia;
       if(numero==null){
			return {
				estado : false,
				mensaje :"EL numero es obligatoria."
			}
		}
		if(idPiso==null){
			return {
				estado : false,
				mensaje :"EL idPiso es obligatoria."
			}
		}
		if(numero.match(regexValid.VALIDENTERO)==null){
			return {
				estado : false,
				mensaje :"EL numero debe ser entero."
			}
		}
		if(!(typeof  vigencia ===  "boolean")){
			return {
				estado : false,
				mensaje :"EL vigencia es obligatoria."
			}
		}
    	return {
		 estado:true,
		 data:{
			dataFormat:{
				"@reqnumero":numero,
				"@reqestado":estado,
				"@reqidpiso":idPiso,
				"@reqvigencia":vigencia ? 1 : 0
			}
		}
	  };
	}
}