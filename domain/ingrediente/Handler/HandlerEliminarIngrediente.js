var dbMetPiso =     require('../Db/Db');
module.exports = {
	async _handler(data) {
		try {
			let dbDatosSistema=await dbMetPiso.eliminar(data.dataFormat);
			dbDatosSistema=dbDatosSistema[0];
			let tempDatos={};
			dbDatosSistema=dbDatosSistema[0];
			tempDatos.estado=dbDatosSistema.estadoflag ? true : false;
			tempDatos.mensaje=dbDatosSistema.mensaje;
	
			if(!tempDatos.estado){
				tempDatos.mensaje="Este registro no se puede eliminar.";
	
			}
			return tempDatos;	
		} catch (error) {
			let tempDatos={};
			tempDatos.estado=false;
			tempDatos.mensaje="No se puede eliminar porque esta asociado a otro registro.";
	
			return tempDatos;	
			
		}

	}
}