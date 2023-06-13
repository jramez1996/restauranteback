const db=require('../../../db/select');
module.exports = {
	async listar(data) {
		let sql="CALL listargastos(@desde,@hasta);";
		let responseProce=await db.select(sql,data); 
		return responseProce;
	 },
	 async registrar(data) {
		let sql="CALL creargasto(@descripcion,@idtipogasto,@costo);";
		let responseProce=await db.select(sql,data); 
		return responseProce;
	},
   async eliminar(data) {
	 let sql="CALL eliminargasto(@id);";
	  let responseProce=await db.select(sql,data); 
	  return responseProce;
  }
}