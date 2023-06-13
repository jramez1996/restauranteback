const db=require('../../../db/select');
module.exports = {
	async listar(data) {
		let sql="CALL listarmesageneral();";
		let responseProce=await db.select(sql,data); 
		return responseProce;
	 },
	 async registrar(data) {
		let sql="CALL `crearmesa`(@reqnumero, @reqestado, @reqidpiso, @reqvigencia);";
		let responseProce=await db.select(sql,data); 
		return responseProce;
	},
	async actualizar(data) {
	   let sql="CALL actualizarmesa(@reqid, @reqnumero, @reqestado, @reqidpiso, @reqvigencia);";
	   let responseProce=await db.select(sql,data); 
	   return responseProce;
   },
   async eliminar(data) {
	let sql="CALL eliminarmesa(@id);";
	let responseProce=await db.select(sql,data); 
	return responseProce;
   }
}