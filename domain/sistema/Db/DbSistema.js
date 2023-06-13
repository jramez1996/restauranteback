const db=require('../../../db/select');
module.exports = {
	async obtenerDatosSistema(data) {
       let sql="CALL obtenerdatossistema()";
       console.log(sql);
	   let responseProce=await db.select(sql); 
	   return responseProce;
	}
}