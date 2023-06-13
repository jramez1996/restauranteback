var dbMetPiso =require('../Db/Db');
module.exports = {
	async _handler(data) {
		console.log("data.dataFormat",data.dataFormat);
		let dbMet=await dbMetPiso.asignarIngredienteProducto(data.dataFormat);
		let responseData=dbMet[0][0];
		let estadoFlag=responseData.estadoflag;
		let mensaje=responseData.mensaje;
		return {
			"estado":estadoFlag==1 ? true : false,
			"mensaje":mensaje
		};
	}
}