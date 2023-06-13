//var dbMet =     require('../../../db/select');
var dbMetPiso =     require('../Db/Db');
module.exports = {
	async _handler(data) {
		let dbDatosSistema=await dbMetPiso.listar();
		dbDatosSistema=dbDatosSistema[0];
		let tempPiso=[];
		dbDatosSistema.map((val)=>{
			tempPiso.push({value:val.idunidadmedida,label:val.descripcion,id:val.idunidadmedida,descripcion:val.descripcion,vigencia:(val.vigencia ? true : false)});
		});
		return {
			"estado":true,
			"data":tempPiso
		};
	}
}