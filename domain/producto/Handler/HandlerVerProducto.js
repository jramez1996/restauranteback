var dbMetPiso =     require('../Db/Db');
module.exports = {
	async _handler(data) {
		let dbDatosSistema=await dbMetPiso.ver(data.dataFormat);
		dbDatosSistema=dbDatosSistema[0];
		let tempPiso=[];
		dbDatosSistema.map((val)=>{
			tempPiso.push({
			id:val.idproducto,
			nombre:val.nombre,
			idCategoria:val.idcategoria,
			stock:val.stock,
			precio:val.precio,
			esplato: (val.esplato ? true : false),
			categoria:val.categoria,
			vigencia:(val.vigencia ? true : false)});
		});
		return {
			"estado":tempPiso.length ? true : false,
			"data":tempPiso
		};
	}
}