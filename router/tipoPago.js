require('dotenv').config();
var express = require('express');
var handlerCargarTipoPago = require('../domain/tipoPago/Handler/HandlerCargarTipoPago');
var requestRegistrarTipoGasto = require('../domain/tipoPago/Request/RequestRegistrarTipoGasto');
var handlerRegistrarTipoGasto = require('../domain/tipoPago/Handler/HandlerRegistrarTipoGasto');

//var requestRegistrarTipoGasto = require('../domain/tipoPago/Request/RequestRegistrarTipoGasto');
var handlerListarTipoGasto = require('../domain/tipoPago/Handler/HandlerListarTipoGasto');


var requestActualizaTipoGasto = require('../domain/tipoPago/Request/RequestActualizaTipoGasto');
var handlerActualizarTipoGasto = require('../domain/tipoPago/Handler/HandlerActualizarTipoGasto');


var requestEliminarTipoGasto = require('../domain/tipoPago/Request/RequestEliminarTipoGasto');
var handlerEliminarTipoGasto = require('../domain/tipoPago/Handler/HandlerEliminarTipoGasto');

/*
var handlerCargarCategoria = require('../domain/categoria/Handler/HandlerCargarCategoria');
*/
var response = require('../response/index');
var router = express.Router();
/**/
router.delete('/eliminarTipoGasto',async function (req, res) {
  try {
    let requestValid=await requestEliminarTipoGasto.esValido(req);
    if(!requestValid.estado){
      return response.responseApi(requestValid);
    }
    let handlerMeth=await handlerEliminarTipoGasto._handler(requestValid.data);
    return response.responseApi(handlerMeth);
   
  } catch (error) {
    return response.responseApi({
      estado : false,
      mensaje : error
    });
  }
    
});
router.get('/listarTipoGasto',async function (req, res) {
  try {
    let handlerMeth=await handlerListarTipoGasto._handler({});
    return response.responseApi(handlerMeth);
   
  } catch (error) {
      /*return   res.json({
        estado : false,
        mensaje : error
      });*/
      return response.responseApi({
        estado : false,
        mensaje : error
      });
    }
    
});
router.post('/nuevoTipoGasto',async function (req, res) {
  try {
    let requestValid=await requestRegistrarTipoGasto.esValido(req);
    if(!requestValid.estado){
      return response.responseApi(requestValid);
    }
    let handlerMeth=await handlerRegistrarTipoGasto._handler(requestValid.data);
    return response.responseApi(handlerMeth);
   
  } catch (error) {
      return response.responseApi({
        estado : false,
        mensaje : error
      });
    }
    
});
router.put('/actualizarTipoGasto',async function (req, res) {
  try {
   
    let requestValid=await requestActualizaTipoGasto.esValido(req);
  
    if(!requestValid.estado){
      return response.responseApi(requestValid);
    }
    let handlerMeth=await handlerActualizarTipoGasto._handler(requestValid.data);
    return response.responseApi(handlerMeth);
   
  } catch (error) {
    console.log("error",error);
    return response.responseApi({
      estado : false,
      mensaje : error
    });
    }
    
});
router.get('/cargarTipoPago',async function (req, res) {
  try {
    let handlerMeth=await handlerCargarTipoPago._handler({});
    return response.responseApi(handlerMeth);
   
  } catch (error) {
    return response.responseApi({
      estado : false,
      mensaje : error
    });
  }
});
module.exports = router;