var dbMetPiso =     require('../Db/Db');
module.exports = {
	async _handler(data) {
		let dbDatosSistema=await dbMetPiso.listar();
		dbDatosSistema=dbDatosSistema[0];
		let tempPiso=[];
		dbDatosSistema.map((val)=>{
			tempPiso.push({value:val.idcategoria,
				label:val.nombre});
		});
		return {
			"estado":true,
			"data":tempPiso
		};
	}
}