const db=require('../../../db/select');
module.exports = {
	async listar(data) {
		let sql="CALL cargartipogasto();";
		let responseProce=await db.select(sql,data); 
		return responseProce;
	 },
	 async registrar(data) {
		let sql="CALL creartipogasto(@vigencia,@descripcion);";
		let responseProce=await db.select(sql,data); 
		return responseProce;
	},
	async actualizar(data) {
	  let sql="CALL actualizartipogasto(@id,@descripcion,@vigencia);";
	  let responseProce=await db.select(sql,data); 
	  return responseProce;
   },
   async eliminar(data) {
	 let sql="CALL eliminartipogasto(@id);";
	  let responseProce=await db.select(sql,data); 
	  return responseProce;
  }
}