//var dbMet =     require('../../../db/select');
var dbMetPiso =     require('../Db/DbMesa');
module.exports = {
	async _handler(data) {
		let dbDatosSistema=await dbMetPiso.listar();
		dbDatosSistema=dbDatosSistema[0];
		let tempPiso=[];
		dbDatosSistema.map((val)=>{
			console.log(dbDatosSistema.length);
			tempPiso.push({id:val.idmesa,numero:val.numero,vigencia:val.vigencia,idPiso:val.idpiso,pisoNumero:val.pisonumero});
		});
		return {
			"estado":true,
			"data":tempPiso
		};
	}
}