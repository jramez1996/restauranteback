var dbMetPiso =     require('../Db/Db');
const moment = require("moment");
module.exports = {
	async _handler(data) {
		let dbDatosSistema=await dbMetPiso.listar(data.dataFormat);
		dbDatosSistema=dbDatosSistema[0];
		let tempPiso=[];
		dbDatosSistema.map((val)=>{
			tempPiso.push({tipoGastoDescripcion:val.tipogastodescripcion,idGasto:val.idgasto,fecha:moment(val.fecha).format('DD-MM-YYYY HH:mm:ss'),idTipoGasto:val.idtipogasto,descripcion:val.descripcion,costo:val.costo.toFixed(2)});
		});
		return {
			"estado":true,
			"data":tempPiso
		};
	}
}