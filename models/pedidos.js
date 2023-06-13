const db=require('../db/index');
const util= require('util');
const query=util.promisify(db.query).bind(db);
module.exports = {
	async cargarPedidoMesa(data) {
        let sqlPedido="CALL cargarpedidomesa("+data+")";
        let valorResponse=await  query(sqlPedido);
        return valorResponse;
	}
}