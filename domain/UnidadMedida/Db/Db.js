const db=require('../../../db/select');
module.exports = {
	async listar(data) {
		let sql="CALL listarunidadgeneral();";
		let responseProce=await db.select(sql,data); 
		return responseProce;
	 },
	 async registrar(data) {
		let sql="CALL crearunidadmedida(@descripcion, @vigencia);";
		let responseProce=await db.select(sql,data); 
		return responseProce;
	},
	async actualizar(data) {
	   let sql="CALL actualizarunidadmedida(@id, @descripcion, @vigencia);";
	   let responseProce=await db.select(sql,data); 
	   return responseProce;
   },
   async eliminar(data) {
	let sql="CALL eliminarunidadmedida(@id);";
	let responseProce=await db.select(sql,data); 
	return responseProce;
   }
}