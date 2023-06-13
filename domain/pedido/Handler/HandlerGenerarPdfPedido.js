//var dbMet =     require('../../../db/select');
var dbMet =     require('../Db/DbPedido');
var dbMetSistema =     require('../../sistema/Db/DbSistema');
var pdfMet = require('../../../pdf/pdf-generator');
module.exports = {
	async _handler(data) {
		let dbDatosSistema=await dbMetSistema.obtenerDatosSistema();
		//console.log("data.hola",data.dataFormat["@mesa"]);
		dbDatosSistema=dbDatosSistema[0].length ? dbDatosSistema[0][0] : null;
		let dbPedido=await dbMet.mostrarPedido(data.dataFormat);
		let responseDataPedido=dbPedido[0].length ? dbPedido[0][0] :null;
		if(responseDataPedido==null){
			return {
				"estado":false,
				"mensaje":"No se encontro pedido pendido pendiente."
			};
		}
		if(dbDatosSistema==null){
			return {
				"estado":false,
				"mensaje":"No se encontro datos del sistema."
			};
		}
		let formatDataSistema={
			nombreEmpresa:dbDatosSistema.nombreempresa,
			direccion:dbDatosSistema.direccion,
			telefono:dbDatosSistema.telefono
		};

		let formatDataPedido={
			fecha:responseDataPedido.fecha,
			idPedido:responseDataPedido.idpedido,
			mesas:responseDataPedido.mesas,
			documentoCliente:responseDataPedido.documentocliente,
			nombreCompletosCliente:responseDataPedido.nombrecompletoscliente,
			nombreCompletosMozo:responseDataPedido.nombrecompletosmozo,
			detalle:JSON.parse(responseDataPedido.detalle)
		  };
		  let responseBase64=await pdfMet.createPDF({dataSistema : formatDataSistema,
			dataPedido:formatDataPedido});
			
		return {
			"estado":true,
			"data":responseBase64
		};
	}
}