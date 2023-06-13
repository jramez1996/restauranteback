var regexValid = require('../../../global/index.js');
module.exports = {
	async esValido(dataReq) {
      body=dataReq.query;
		if(
			!body.hasOwnProperty("mesa")
			){
				return {
				 estado : false,
				 mensaje :"se requiere de mesa."
				}
		}	
		
	   let mesa=body.mesa==null || body.mesa=="" ? null : body.mesa;
       if(mesa==null){
			return {
				estado : false,
				mensaje :"EL mesa es obligatoria."
			}
		}
		if(mesa.match(regexValid.VALIDENTERO)==null){
			return {
				estado : false,
				mensaje :"EL mesa debe ser entero."
			}
		}
	   
	   return {
		estado:true,
		data:{
			mesa:mesa,
			dataFormat:{
				"@mesa":mesa
			}
		}
	  };
	}
}