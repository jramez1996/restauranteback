//var dbMet =     require('../../../db/select');
var dbMetPiso =     require('../Db/DbPiso');
module.exports = {
	async _handler(data) {
		let dbDatosSistema=await dbMetPiso.listar();
		dbDatosSistema=dbDatosSistema[0];
		let tempPiso=[];
		dbDatosSistema.map((val)=>{
			console.log(dbDatosSistema.length);
			tempPiso.push({id:val.idpiso,numero:val.numero,vigencia:(val.vigencia ? true : false)});
		});
		return {
			"estado":true,
			"data":tempPiso
		};
	}
}