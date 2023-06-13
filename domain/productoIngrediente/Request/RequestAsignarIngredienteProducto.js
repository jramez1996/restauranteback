var regexValid = require('../../../global/index.js');
//var global =     require('../../../global/global.js');

module.exports = {
	async esValido(dataReq) {
      body=dataReq.body;
		if(
			!body.hasOwnProperty("detalles") ||
			!body.hasOwnProperty("idProducto")
			){
				return {
				 estado : false,
				 mensaje :"se requiere de detalles,idProducto."
				}
		}	
		
	   let detalles=body.detalles==null || body.detalles=="" ? null : body.detalles;
	   let idProducto=body.idProducto==null || body.idProducto=="" ? null : body.idProducto;
       if(idProducto==null){
		return {
			estado : false,
			mensaje :"EL idProducto es obligatoria."
		}
	   }
	   if(idProducto.toString().match(regexValid.VALIDENTERO)==null ){
			return {
				estado : false,
				mensaje :"EL idProducto es numerico."
			}
	   }
	   if(detalles==null){
			return {
				estado : false,
				mensaje :"EL detalles es obligatoria."
			}
		}
		if(!Array.isArray(detalles)){
			return {
				estado : false,
				mensaje :"EL detalles debe ser array."
			}
		}
		
		let notValidDetalle=detalles.filter((value)=>{
			return !value.hasOwnProperty("idIngrediente") || !value.hasOwnProperty("cantidad") || !value.hasOwnProperty("vigencia");
		});
		
		if(notValidDetalle.length){
			return {
				estado : false,
				mensaje :"En el detalle la propiedades idIngrediente,cantidad,vigencia son obligatorias."
			}
		}
		
		let notValidDetalleIngrediente=detalles.filter((value)=>{
			return value.idIngrediente.toString().match(regexValid.VALIDENTERO)==null;
		});
		if(notValidDetalleIngrediente.length){
			return {
				estado : false,
				mensaje :"En el detalle la propiedades idIngrediente debe ser numerico."
			}
		}
		let notValidDetalleCantidad=detalles.filter((value)=>{
			return value.cantidad.toString().match(regexValid.VALIDENTERO)===null;
		});
		if(notValidDetalleCantidad.length){
			return {
				estado : false,
				mensaje :"En el detalle la propiedades cantidad debe ser numerico."
			}
		}

		let notValidDetalleVigencia=detalles.filter((value)=>{
			return !( typeof value.vigencia === "boolean");
		});

		if(notValidDetalleVigencia.length){

			return {
				estado : false,
				mensaje :"En el detalle la propiedades vigencia debe ser boolean."
			}
		}

		let reqIdIngrediente="";
		let reqArrayIdIngrediente=[];
		let reqArrayCantidad=[];
		let reqCantidad="";
		let reqArrayVigencia=[];
		let reqVigencia="";
		
		detalles.forEach((value)=>{
			reqArrayIdIngrediente.push(value.idIngrediente);
			reqArrayCantidad.push(value.cantidad);
			reqArrayVigencia.push(value.vigencia ? "1" : "0");
			
		});
		reqIdIngrediente=reqArrayIdIngrediente.join(",");
		reqCantidad=reqArrayCantidad.join(",");
		reqVigencia=reqArrayVigencia.join(",");
	   return {
		estado:true,
		data:{
			dataFormat:{
				"@reqidproducto":idProducto,
				"@reqingredientes":reqIdIngrediente,
				"@reqcantidades":reqCantidad,
				"@reqvigencias":reqVigencia
			}
		}
	  };
	}
}