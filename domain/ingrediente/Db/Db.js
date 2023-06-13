const db=require('../../../db/select');
module.exports = {
	async listar(data) {
		let sql="CALL listaringredientegeneral();";
		let responseProce=await db.select(sql,data); 
		return responseProce;
	 },
	 async registrar(data) {
		let sql="CALL crearingrediente(@nombre,@vigencia,@precio,@idUnidadMedida);";
		let responseProce=await db.select(sql,data); 
		return responseProce;
	},
	async actualizar(data) {
		let sql="CALL actualizaringrediente(@id,@nombre,@vigencia,@precio,@idUnidadMedida);";
		let responseProce=await db.select(sql,data); 
		return responseProce;
   },
   async cargarIngrediente(data) {
	let sql="CALL `cargaringrediente`();";
	let responseProce=await db.select(sql,data); 
	return responseProce;
  },
  async eliminar(data) {
	let sql="CALL `eliminaringrediente`(@id);";
	let responseProce=await db.select(sql,data); 
	return responseProce;
  }
}