const db=require('../../../db/select');
module.exports = {
	async listar(data) {
		let sql="CALL cargarpedidosrealizados(@desde,@hasta);";
		let responseProce=await db.select(sql,data); 
		return responseProce;
	 },
	 
}