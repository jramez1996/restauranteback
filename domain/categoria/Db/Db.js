const db=require('../../../db/select');
module.exports = {
	async listar(data) {
		let sql="CALL listarcategoriageneral();";
		let responseProce=await db.select(sql,data); 
		return responseProce;
	 },
	 async registrar(data) {
		let sql="CALL crearcategoria(@vigencia,@nombre);";
		let responseProce=await db.select(sql,data); 
		return responseProce;
	},
	async actualizar(data) {
	  let sql="CALL actualizarcategoria(@id,@vigencia,@nombre);";
	   let responseProce=await db.select(sql,data); 
	   return responseProce;
   },
   async eliminar(data) {
	 let sql="CALL eliminarcategoria(@id);";
	  let responseProce=await db.select(sql,data); 
	  return responseProce;
  }
}