var dbMetPiso =     require('../Db/Db');
const moment = require("moment");
module.exports = {
	async _handler(data) {
		let dbDatosSistema=await dbMetPiso.listar(data.dataFormat);
		dbDatosSistema=dbDatosSistema[0];
		let tempPiso=[];
		console.log("dbDatosSistema",dbDatosSistema);
		dbDatosSistema.map((val)=>{
			tempPiso.push({idPedido:val.idpedido,vigencia:val.vigencia ? true : false ,fecha:moment(val.fecha).format('DD-MM-YYYY HH:mm:ss'),documento:val.documento,nombreCompletos:val.nombre,tipoDocumento:val.tipodocumento,total:val.total.toFixed(2)});
		});
		return {
			"estado":true,
			"data":tempPiso
		};
	}
}