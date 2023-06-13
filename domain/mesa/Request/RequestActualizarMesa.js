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
	   let id=body.id==null || body.id=="" ? null : body.id.toString(); 
	   let numero=body.numero==null || body.numero=="" ? null : body.numero.toString();
	   let estado=null;
	   let idPiso=body.idPiso==null || body.idPiso=="" ? null : body.idPiso.toString();
	   let vigencia=body.vigencia==null || body.vigencia==="" ? null : body.vigencia;
	   if(id==null){
			return {
				estado : false,
				mensaje :"EL id es obligatoria."
			}
		}
		if(id.match(regexValid.VALIDENTERO)==null){
			return {
				estado : false,
				mensaje :"EL id debe ser entero."
			}
		}  
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
		if(idPiso.match(regexValid.VALIDENTERO)==null){
			return {
				estado : false,
				mensaje :"EL idPiso debe ser entero."
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
		//(@reqid, @reqnumero, @reqestado, @reqidpiso, @reqvigencia)
    	return {
		 estado:true,
		 data:{
			dataFormat:{
				"@reqid":id,
				"@reqnumero":numero,
				"@reqestado":estado,
				"@reqidpiso":idPiso,
				"@reqvigencia":vigencia ? 1 : 0
			}
		}
	  };
	}
}