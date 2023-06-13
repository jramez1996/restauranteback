var dbMetPiso =     require('../Db/Db');
module.exports = {
	async _handler(data) {
		let dbDatosSistema=await dbMetPiso.listar();
		dbDatosSistema=dbDatosSistema[0];
		let tempPiso=[];
		dbDatosSistema.map((val)=>{
			tempPiso.push({value:val.idtipogasto,
				label:val.descripcion,vigencia:val.vigencia ? true : false});
		});
		return {
			"estado":true,
			"data":tempPiso
		};
	}
}