var dbMetPiso =     require('../Db/Db');
module.exports = {
	async _handler(data) {
		let dbDatosSistema=await dbMetPiso.cargar(data.dataFormat);
		dbDatosSistema=dbDatosSistema[0];
		let tempPiso=[];
		dbDatosSistema.map((val)=>{
			tempPiso.push({value:val.idtipogasto,
				value:val.codigoubigeo,label:val.descripcion,nivel:val.nivel,codigoUbigeo:val.codigoubigeo});
		});
		return {
			"estado":true,
			"data":tempPiso
		};
	}
}