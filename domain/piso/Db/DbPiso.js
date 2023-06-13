const db=require('../../../db/select');
module.exports = {
	async listar(data) {
		let sql="CALL listarpisogeneral();";
		let responseProce=await db.select(sql,data); 
		return responseProce;
	 },
	 async registrar(data) {
		let sql="CALL crearpiso(@vigencia, @numero);";
		let responseProce=await db.select(sql,data); 
		return responseProce;
	},
	async actualizar(data) {
	   let sql="CALL actualizarpiso(@id,@vigencia,@numero);";
	   let responseProce=await db.select(sql,data); 
	   return responseProce;
   },
   async eliminar(data) {
	  let sql="CALL eliminarpiso(@id);";
	  let responseProce=await db.select(sql,data); 
	  return responseProce;
  }
}