var dbMetPiso =     require('../Db/Db');
module.exports = {
	async _handler(data) {
		let dbDatosSistemaGasto=await dbMetPiso.obtenerGastosTotalesMesActual();
		let dbDatosSistemaSumaTotal=dbDatosSistemaGasto[0][0].sumatotal;

		let dbDatosSistemaPedidos=await dbMetPiso.obtenerPedidosTotalesMesActual();
		let dbDatosSistemaPedidosTotal=dbDatosSistemaPedidos[0][0].sumatotal;

		let dbDatosSistemaClientes=await dbMetPiso.obtenerTotalClientesMesActual();
		let dbDatosSistemaClientesTotal=dbDatosSistemaClientes[0][0].totalclientes;
		return {
			"estado":true,
			"data":{
				"gastoTotal":dbDatosSistemaSumaTotal,
				"pedidoTotal":dbDatosSistemaPedidosTotal,
				"clientesTotal":dbDatosSistemaClientesTotal
			}
		};
	}
}