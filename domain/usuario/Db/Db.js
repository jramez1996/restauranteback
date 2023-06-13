const db=require('../../../db/select');
module.exports = {
	async listar(data) {
		let sql="CALL listarmozo();";
		let responseProce=await db.select(sql,data); 
		return responseProce;
	 },
	 async registrar(data) {
		let sql="CALL crearmozo(@nombreCompleto,@vigencia,@documentoIdentidad,@usuario,@contrasenia,@reqIdUbigeo,@perfil);";
		let responseProce=await db.select(sql,data); 
		return responseProce;
	},
	async actualizar(data) {
	  let sql="CALL actualizarmozo(@idMozo,@nombreCompleto,@reqIdUbigeo,@vigencia);";
	  let responseProce=await db.select(sql,data); 
	  return responseProce;
   },
   async eliminar(data) {
	 let sql="CALL eliminarcategoria(@id);";
	  let responseProce=await db.select(sql,data); 
	  return responseProce;
  }
}