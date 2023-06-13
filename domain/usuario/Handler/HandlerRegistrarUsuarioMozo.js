var dbMetPiso =     require('../Db/Db');
var envioCorreo =     require('../../../email/enviarCorreo');
module.exports = {
	async _handler(data) {
		//contrasenia
		//@perfil
		var caracteres = "abcdefghijkmnpqrtuvwxyzABCDEFGHJKMNPQRTUVWXYZ2346789";
       var contraseña = "";
       for (i=0; i<10; i++) contraseña +=caracteres.charAt(Math.floor(Math.random()*caracteres.length)); 
	   console.log(contraseña)
	   
		data.dataFormat["@perfil"]="MOZO";
		data.dataFormat["@contrasenia"]=contraseña;
		let dbDatosSistema=await dbMetPiso.registrar(data.dataFormat);
		dbDatosSistema=dbDatosSistema[0];
		envioCorreo.enviarCorreo({
			vista:"establecer",
			correo:data.dataFormat["@usuario"],
			tema:data.dataFormat["@usuario"],
			data:{
				empresa:"establecer Contraseña",
				usuario:data.dataFormat["@usuario"],
				contrasenia:data.dataFormat["@contrasenia"]
			}
		});
		//let rptamsg=enviarcorreo();
		let tempDatos={};
		dbDatosSistema=dbDatosSistema[0];
		tempDatos.estado=dbDatosSistema.estadoflag ? true : false;
		tempDatos.mensaje=dbDatosSistema.mensaje;
		return tempDatos;
	}
}