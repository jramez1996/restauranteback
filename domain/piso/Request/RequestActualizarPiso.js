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
	   let id=body.id==null || body.id=="" ? null : body.id.toString();
	   let numero=body.numero==null || body.numero=="" ? null : body.numero.toString();
	   let vigencia=body.vigencia===null || body.vigencia==="" ? null : body.vigencia;
	   console.log("vigencia",vigencia);
	   
	   if(id==null){
		return {
			estado : false,
			mensaje :"EL id es obligatoria."
		}
	   }	  
       if(numero==null){
			return {
				estado : false,
				mensaje :"EL numero es obligatoria."
			}
		}
		console.log("id",id);
		/*if(id.match(regexValid.VALIDENTERO)==null){
			return {
				estado : false,
				mensaje :"EL numero debe ser entero."
			}
		}*/
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
				"@id":id,
				"@numero":numero,
				"@vigencia":vigencia ? 1 : 0
			}
		}
	  };
	}
}