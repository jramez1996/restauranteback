var regexValid = require('../../../global/index.js');
var global =     require('../../../global/global.js');

module.exports = {
	async esValido(dataReq) {
      body=dataReq.body;
		if(
			!body.hasOwnProperty("mesas")
			){
				return {
				 estado : false,
				 mensaje :"se requiere de mesas."
				}
		}	
		if(
			!body.hasOwnProperty("detalle")
			){
				return {
					estado : false,
					mensaje :"se requiere de detalle."
				}
	   }
	   let mesas=body.mesas==null || body.mesas=="" ? null : body.mesas;
	   let detalle=body.detalle==null || body.detalle=="" ? null : body.detalle;
	   let idMozo=await  global.toIdMozo();
	    if(!idMozo){
			return {
				estado : false,
				mensaje :"EL idMozo es obligatoria."
			}
		}
		if(mesas==null){
			return {
				estado : false,
				mensaje :"EL mesas es obligatoria."
			}
		}
		let notValidMesas=mesas.split(",").filter((value)=>{
			return value.match(regexValid.VALIDENTERO)==null;
		});
		if(notValidMesas.length>0){
			return {
				estado : false,
				mensaje :"EL mesas debe ser entero por comas."
			}
		}
		if(!Array.isArray(detalle)){
			return {
				estado : false,
				mensaje :"EL detalle debe ser array."
			}
		}
		let notValidDetalle=detalle.filter((value)=>{
			return !value.hasOwnProperty("cantidad") || !value.hasOwnProperty("id")
		});
		if(notValidDetalle.length){
			return {
				estado : false,
				mensaje :"En el detalle la propiedades cantidad,id son obligatorias."
			}
		}
	   // GENERAR DATA PARA IDPRODUCTO
	   let detalleIdProductos=[];
	   let detalleCantidad=[];
	   detalle.forEach(element => {
			detalleIdProductos.push(element.id);
			detalleCantidad.push(element.cantidad);

	   });	
	   detalleIdProductos=detalleIdProductos.join(",");	
	   detalleCantidad=detalleCantidad.join(",");

	   return {
		estado:true,
		data:{
			idMozo:idMozo,
			mesas:mesas,
			detalle:detalle,
			dataFormat:{
				"@mesas":mesas,
				"@detalleProducto":detalleIdProductos,
				"@detalleCantidad":detalleCantidad,
				"@idMozo":idMozo
			}
		}
	  };
	}
}