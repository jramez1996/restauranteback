var dbMetPiso =     require('../Db/Db');
module.exports = {
	async _handler(data) {
		let dbDatosSistema=await dbMetPiso.listar();
		dbDatosSistema=dbDatosSistema[0];
		let tempPiso=[];
		dbDatosSistema.map((val)=>{
			console.log(dbDatosSistema.length);
			tempPiso.push({idsUbigeos:val.idsubigeos,id:val.idmozo,nombreCompleto:val.nombrecompleto,documentoIdentidad:val.documentoidentidad,idUsuario:val.idusuario,usuario:val.usuario,idOrigen:val.idorigen,vigencia:(val.vigencia ? true : false)});
		});
		return {
			"estado":true,
			"data":tempPiso
		};
	}
}