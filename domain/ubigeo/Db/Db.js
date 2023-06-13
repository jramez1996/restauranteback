const db=require('../../../db/select');
module.exports = {
	async cargar(data) {
		let sql="CALL cargarubigeo(@codubigeo);";
		let responseProce=await db.select(sql,data); 
		return responseProce;
	 },
	 
}