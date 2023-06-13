var regexValid = require('../../../global/index.js');
module.exports = {
	async esValido(dataReq) {
      body=dataReq.query;
		if(
			!body.hasOwnProperty("id")
			){
				return {
				 estado : false,
				 mensaje :"se requiere de id."
				}
		}	
		
	   let id=body.id==null || body.id=="" ? null : body.id;
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
	   
	   return {
		estado:true,
		data:{
			dataFormat:{
				"@id":id
			}
		}
	  };
	}
}