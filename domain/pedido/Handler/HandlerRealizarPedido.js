//var dbMet =     require('../../../db/select');
var dbMet =     require('../Db/DbPedido');
module.exports = {
	async _handler(data) {
		let dbPedido=await dbMet.realizarPedido(data.dataFormat);
		let responseData=dbPedido[0][0];
		let estadoFlag=responseData.estadoflag;
		let mensaje=responseData.mensaje;
		return {
			"estado":estadoFlag==1 ? true : false,
			"mensaje":mensaje
		};
	}
}