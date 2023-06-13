const db=require('../../../db/select');
module.exports = {
	async listar(data) {
		let sql="CALL listarproductogeneral();";
		let responseProce=await db.select(sql,data); 
		return responseProce;
	 },
	 async registrar(data) {
		let sql="CALL crearproducto(@reqnombre, @reqvigencia,@reqidcategoria,@reqprecio,@reqesplato);";
		let responseProce=await db.select(sql,data); 
		return responseProce;
	},
	async actualizar(data) {
	   let sql="CALL actualizarproducto(@id,@reqnombre, @reqvigencia,@reqidcategoria,@reqprecio,@reqesplato);";
	   let responseProce=await db.select(sql,data); 
	   return responseProce;
	  // return {};
   },
   async eliminar(data) {
	let sql="CALL eliminarproducto(@id);";
	let responseProce=await db.select(sql,data); 
	return responseProce;
   },
   async ver(data) {
	//let sql="CALL verproducto(@id);";
	let sql="CALL verproducto(@id);";
	let responseProce=await db.select(sql,data); 
	return responseProce;
 }
}