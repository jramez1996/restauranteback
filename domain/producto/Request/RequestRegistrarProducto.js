var regexValid = require('../../../global/index.js');
module.exports = {
	async esValido(dataReq) {
      body=dataReq.body;
	  if(
			!body.hasOwnProperty("nombre") 
			){
				return {
				 estado : false,
				 mensaje :"se requiere de nombre."
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
			!body.hasOwnProperty("idCategoria")
			){
				return {
				 estado : false,
				 mensaje :"se requiere de idCategoria."
				}
		}
		if(
			!body.hasOwnProperty("precioVenta")
			){
				return {
				 estado : false,
				 mensaje :"se requiere de precioVenta."
				}
	   }
	   if(
		!body.hasOwnProperty("esPlato")
		){
			return {
			 estado : false,
			 mensaje :"se requiere de esPlato."
			}
   		}			
	   let nombre=body.nombre==null || body.nombre=="" ? null : body.nombre;
	   let vigencia=body.vigencia==null || body.vigencia==="" ? null : body.vigencia;
       let idCategoria=body.idCategoria==null || body.idCategoria=="" ? null : body.idCategoria.toString();
       let precioVenta=body.precioVenta==null || body.precioVenta=="" ? null : body.precioVenta.toString();
       let esPlato=body.esPlato==null || body.esPlato==="" ? null : body.esPlato;
	   if(precioVenta==null){
		return {
			estado : false,
			mensaje :"EL precio es requerida ."
		}
	   }
	   if( isNaN(Number(precioVenta)) ){
		return {
			estado : false,
			mensaje :"EL precioVenta debe ser decimal."
		}
	   } 
	   if(idCategoria==null){
		return {
			estado : false,
			mensaje :"EL categoria es requerida."
		}
	   }
	   if(idCategoria.match(regexValid.VALIDENTERO)==null){
		return {
			estado : false,
			mensaje :"EL categoria es entero."
		}
	   }   
	   if(nombre==null){
			return {
				estado : false,
				mensaje :"EL nombre es requerido."
			}
		}
		if(nombre.length>255){
			return {
				estado : false,
				mensaje :"EL nombre no debe sobrepasar los 255 digitos ."
			}
		}
		if(!(typeof  vigencia ===  "boolean")){
			return {
				estado : false,
				mensaje :"EL vigencia debe ser boolean."
			}
		}
		if(!(typeof  esPlato ===  "boolean")){
			return {
				estado : false,
				mensaje :"EL esPlato debe ser boolean."
			}
	   }
	   return {
		estado:true,
		data:{
			dataFormat:{
				"@reqnombre":nombre,
				"@reqidcategoria":parseInt(idCategoria),
				"@reqprecio":precioVenta,
				"@reqesplato": esPlato ? 1 : 0,
				"@reqvigencia":vigencia ? 1 : 0
			}
		}
	  };
	}
}