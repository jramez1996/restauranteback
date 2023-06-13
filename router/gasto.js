require('dotenv').config();
var express = require('express');
var requestRegistrarGasto = require('../domain/gasto/Request/RequestRegistrarGasto');
var handlerRegistrarGasto = require('../domain/gasto/Handler/HandlerRegistrarGasto');

var requestListarGasto = require('../domain/gasto/Request/RequestListarGasto');
var handlerListarGasto = require('../domain/gasto/Handler/HandlerListarGasto');

var requestEliminarGasto = require('../domain/gasto/Request/RequestEliminarGasto');
var handlerEliminaGasto = require('../domain/gasto/Handler/HandlerEliminaGasto');

/*
var handlerCargarCategoria = require('../domain/categoria/Handler/HandlerCargarCategoria');
var requestRegistrarCategoria = require('../domain/categoria/Request/RequestRegistrarCategoria');
var handlerRegistrarCategoria = require('../domain/categoria/Handler/HandlerRegistrarCategoria');

var requestActualizarCategoria = require('../domain/categoria/Request/RequestActualizaCategoria');
var handlerActualizarCategoria = require('../domain/categoria/Handler/HandlerActualizarCategoria');
*/
var response = require('../response/index');
var router = express.Router();
/*router.get('/listarCategoriaGeneral',async function (req, res) {
  try {
    let handlerMeth=await handlerCategoria._handler({});
    return response.responseApi(handlerMeth);
   
  } catch (error) {
    console.log("error",error);
    return   res.json({
        estado : false,
        mensaje : error
      });
    }
    
});

router.put('/actualizarCategoria',async function (req, res) {
  try {
   
    let requestValid=await requestActualizarCategoria.esValido(req);
  
    if(!requestValid.estado){
      return response.responseApi(requestValid);
    }
    let handlerMeth=await handlerActualizarCategoria._handler(requestValid.data);
    return response.responseApi(handlerMeth);
   
  } catch (error) {
    console.log("error",error);
    return   res.json({
        estado : false,
        mensaje : error
      });
    }
    
});
*/
router.delete('/eliminarGasto',async function (req, res) {
  try {
    let requestValid=await requestEliminarGasto.esValido(req);
    if(!requestValid.estado){
      return response.responseApi(requestValid);
    }
    let handlerMeth=await handlerEliminaGasto._handler(requestValid.data);
    return response.responseApi(handlerMeth);
   
  } catch (error) {
    return response.responseApi({
      estado : false,
      mensaje : error
    });
  }
    
});
router.post('/nuevoGasto',async function (req, res) {
  try {
    let requestValid=await requestRegistrarGasto.esValido(req);
    if(!requestValid.estado){
      return response.responseApi(requestValid);
    }
    let handlerMeth=await handlerRegistrarGasto._handler(requestValid.data);
    return response.responseApi(handlerMeth);
   
  } catch (error) {
    console.log("error",error);
    return response.responseApi({
      estado : false,
      mensaje : error
    });
  }
    
});
router.get('/listarGasto',async function (req, res) {
  try {
    let requestValid=await requestListarGasto.esValido(req);
    if(!requestValid.estado){
      return response.responseApi(requestValid);
    }
    let handlerMeth=await handlerListarGasto._handler(requestValid.data);
    return response.responseApi(handlerMeth);
   
  } catch (error) {
    return response.responseApi({
      estado : false,
      mensaje : error
    });
  }
    
});

/*
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
*/
module.exports = router;