const db=require('../../../db/select');
module.exports = {
	async realizarPedido(data) {
	   let sql="CALL `procesarpedido`(@detalleProducto, @detalleCantidad, @mesas,@idMozo);"
	   let responseProce=await db.select(sql,data); 
	   return responseProce;
	},
	async mostrarPedido(data) {
		let sql="CALL mostrarpedido02(@mesa);";
		let responseProce=await db.select(sql,data); 
		return responseProce;
	}
}