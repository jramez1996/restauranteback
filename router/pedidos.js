require('dotenv').config();
var express = require('express');
var requestPedido = require('../domain/pedido/Request/RequestRealizarPedido');
var handlerPedido = require('../domain/pedido/Handler/HandlerRealizarPedido');

var requestPedidoPdf = require('../domain/pedido/Request/RequestGenerarPdfPedido');
var handlerPedidoPdf = require('../domain/pedido/Handler/HandlerGenerarPdfPedido');
var response = require('../response/index');
var router = express.Router();
router.post('/realizarPedido',async function (req, res) {
  try {
    let requestValid=await requestPedido.esValido(req);
    if(!requestValid.estado){
      return response.responseApi(requestValid);
    }
    let handlerMeth=await handlerPedido._handler(requestValid.data);
    return response.responseApi(handlerMeth);
   
  } catch (error) {
    console.log("error",error);
    return   res.json({
        estado : false,
        mensaje : error
      });
    }
    
});
router.get('/mostarPedidoPorMesaPdf',async function (req, res) {
  try {
    let requestValid=await requestPedidoPdf.esValido(req);
    if(!requestValid.estado){
      return response.responseApi(requestValid);
    }
    let handlerMeth=await handlerPedidoPdf._handler(requestValid.data);
    console.log("handlerMeth",requestValid.data);
    return response.responseApi(handlerMeth);
   
  } catch (error) {
    console.log("error",error);
    return   res.json({
        estado : false,
        mensaje : error
      });
  }
  /*let reqIdPedido=req.query.reqIdPedido=="" || req.query.reqIdPedido==undefined ? "null" : req.query.reqIdPedido;
  let sqlDatosSistema="CALL obtenerdatossistema()";
  let valorResponseDatosSistema=(await  query(sqlDatosSistema))[0][0];
  let sqlDatosPedido="CALL mostrarpedido("+reqIdPedido+")";
  let valorResponsePedido=(await  query(sqlDatosPedido))[0][0];

  let formatDataSistema={
    nombreEmpresa:valorResponseDatosSistema.nombreempresa,
    direccion:valorResponseDatosSistema.direccion,
    telefono:valorResponseDatosSistema.telefono
  };
  let formatDataPedido={
    fecha:valorResponsePedido.fecha,
    idPedido:valorResponsePedido.idpedido,
    mesas:valorResponsePedido.mesas,
    documentoCliente:valorResponsePedido.documentocliente,
    nombreCompletosCliente:valorResponsePedido.nombrecompletoscliente,
    nombreCompletosMozo:valorResponsePedido.nombrecompletosmozo,
    detalle:JSON.parse(valorResponsePedido.detalle)
  };
  let responseBase64=await pdfMet.createPDF({dataSistema : formatDataSistema,
    dataPedido:formatDataPedido});
  return   res.json({
    estado : true,
    dataSistema : formatDataSistema,
    dataPedido:formatDataPedido,
    base64Pdf:responseBase64
  }); */
});
module.exports = router;