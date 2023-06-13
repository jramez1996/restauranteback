var dbMetPiso =     require('../Db/Db');
module.exports = {
	async _handler(data) {
		let dbDatosSistema=await dbMetPiso.listar();
		dbDatosSistema=dbDatosSistema[0];
		let tempPiso=[];
		dbDatosSistema.map((val)=>{
			console.log(dbDatosSistema.length);
			tempPiso.push({id:val.idcategoria,nombre:val.nombre,vigencia:(val.vigencia ? true : false)});
		});
		return {
			"estado":true,
			"data":tempPiso
		};
	}
}