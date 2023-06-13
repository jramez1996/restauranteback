var regexValid = require('../../../global/index.js');
module.exports = {
	async esValido(dataReq) {
      body=dataReq.query;
 	  if(
		!body.hasOwnProperty("fechaDesde")
		){
			return {
				estado : false,
				mensaje :"se requiere de fechaDesde."
			}
		}	
		if(
			!body.hasOwnProperty("fechaHasta")
			){
				return {
					estado : false,
					mensaje :"se requiere de fechaHasta."
				}
		}		
	   let fechaDesde=body.fechaDesde==null || body.fechaDesde=="" ? null : body.fechaDesde;
	   let fechaHasta=body.fechaHasta==null || body.fechaHasta=="" ? null : body.fechaHasta;
       /*if(fechaDesde==null){
			return {
				estado : false,
				mensaje :"EL fechaDesde es obligatoria."
			}
		}
		if(fechaHasta==null){
			return {
				estado : false,
				mensaje :"EL fechaHasta es obligatoria."
			}
		}*/
	   return {
		estado:true,
		data:{
			dataFormat:{
				"@desde":fechaDesde,
				"@hasta":fechaHasta
			}
		}
	  };
	}
}