var dbMetPiso =require('../Db/Db');
module.exports = {
	async _handler(data) {
		let dbDatosSistema=await dbMetPiso.listar(data.dataFormat);
		dbDatosSistema=dbDatosSistema[0];
		let tempPiso=[];
		dbDatosSistema.map((val)=>{
			tempPiso.push({registrado:true,cantidad:val.cantidad,idIngrediente:val.idingrediente,nombreIngrediente:val.nombreingrediente,idProducto:val.idproducto,nombreProducto:val.nombreproducto,nombreUnidadMedida:val.nombreunidadmedida,vigencia:(val.vigencia ? true : false)});
		});
		return {
			"estado":true,
			"data":tempPiso
		};
	}
}