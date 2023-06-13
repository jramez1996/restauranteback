const db=require('../../../db/select');
module.exports = {
	async obtenerGastosTotalesMesActual(data) {
		let sql="CALL sumatotalgastomes();";
		let responseProce=await db.select(sql,data); 
		return responseProce;
	 },
	 async obtenerPedidosTotalesMesActual(data) {
		let sql="CALL sumatotalpedidomes();";
		let responseProce=await db.select(sql,data); 
		return responseProce;
	 },
	 async obtenerTotalClientesMesActual(data) {
		let sql="CALL totalclienteregistrado();";
		let responseProce=await db.select(sql,data); 
		return responseProce;
	 },
}