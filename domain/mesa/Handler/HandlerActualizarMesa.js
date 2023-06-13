var dbMetPiso =     require('../Db/DbMesa');
module.exports = {
	async _handler(data) {
		let dbDatosSistema=await dbMetPiso.actualizar(data.dataFormat);
		dbDatosSistema=dbDatosSistema[0];
		let tempDatos={};
		dbDatosSistema=dbDatosSistema[0];
		tempDatos.estado=dbDatosSistema.estadoflag ? true : false;
		tempDatos.mensaje=dbDatosSistema.mensaje;
		return tempDatos;
	}
}