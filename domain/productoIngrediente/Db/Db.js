const db=require('../../../db/select');
module.exports = {
	async listar(data) {
		let sql="CALL listarproductoingrediente(@id);";
		let responseProce=await db.select(sql,data); 
		return responseProce;
	 },
	async asignarIngredienteProducto(data) {
		
		let sql="CALL asignaringredienteproducto(@reqidproducto, @reqingredientes,@reqcantidades,@reqvigencias);"
		let responseProce=await db.select(sql,data); 
		return responseProce;
	 },
}