var regexValid = require('../../../global/index.js');
module.exports = {
	async esValido(dataReq) {
      body=dataReq.query;
	  if(
		!body.hasOwnProperty("codigoPadre") 
		){
			return {
			 estado : false,
			 mensaje :"se requiere de codigoPadre."
			}
	  }
	  
	   let codigoPadre=body.codigoPadre==null || body.codigoPadre=="" ? null : body.codigoPadre.toString();
	  	if(codigoPadre!=null){
			if(codigoPadre.match(regexValid.VALIDENTERO)==null){
				return {
					estado : false,
					mensaje :"EL numero debe ser entero."
				}
			}
	    }
	   return {
		estado:true,
		data:{
			dataFormat:{
				"@codubigeo":codigoPadre
			}
		}
	  };
	}
}