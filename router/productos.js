require('dotenv').config();
var express = require('express');
var handlerProducto = require('../domain/producto/Handler/HandlerListarProducto');

var requestRegistrarProducto = require('../domain/producto/Request/RequestRegistrarProducto');
var handlerRegistrarProducto = require('../domain/producto/Handler/HandlerRegistrarProducto');

var requestActualizarProducto = require('../domain/producto/Request/RequestActualizarProducto');
var handlerActualizarProducto = require('../domain/producto/Handler/HandlerActualizarProducto');

var requestEliminarProducto = require('../domain/producto/Request/RequestEliminarProducto');
var handlerEliminarProducto = require('../domain/producto/Handler/HandlerEliminarProducto');

var requestVerProducto = require('../domain/producto/Request/RequestVerProducto');
var handlerVerProducto = require('../domain/producto/Handler/HandlerVerProducto');

var response = require('../response/index');
var router = express.Router();
router.get('/listarProductoGeneral',async function (req, res) {
  try {
    let handlerMeth=await handlerProducto._handler({});
    return response.responseApi(handlerMeth);
   
  } catch (error) {
    console.log("error",error);
    return   res.json({
        estado : false,
        mensaje : error
      });
    }
    
});
router.post('/nuevoProducto',async function (req, res) {
  try {
    let requestValid=await requestRegistrarProducto.esValido(req);
    if(!requestValid.estado){
      return response.responseApi(requestValid);
    }
    let handlerMeth=await handlerRegistrarProducto._handler(requestValid.data);
    return response.responseApi(handlerMeth);
   
  } catch (error) {
    console.log("error",error);
    return   res.json({
        estado : false,
        mensaje : error
      });
    }
    
});
router.put('/actualizarProducto',async function (req, res) {
  try {
   
    let requestValid=await requestActualizarProducto.esValido(req);
  
    if(!requestValid.estado){
      return response.responseApi(requestValid);
    }
    let handlerMeth=await handlerActualizarProducto._handler(requestValid.data);
    return response.responseApi(handlerMeth);
   
  } catch (error) {
    console.log("error",error);
    return   res.json({
        estado : false,
        mensaje : error
      });
    }
    
});
router.delete('/eliminarProducto',async function (req, res) {
  try {
    let requestValid=await requestEliminarProducto.esValido(req);
    if(!requestValid.estado){
      return response.responseApi(requestValid);
    }
    let handlerMeth=await handlerEliminarProducto._handler(requestValid.data);
    return response.responseApi(handlerMeth);
   
  } catch (error) {
    return response.responseApi({
      estado : false,
      mensaje : error
    });
  }
    
});
router.get('/verProducto',async function (req, res) {
  try {
    let requestValid=await requestVerProducto.esValido(req);
    if(!requestValid.estado){
      return response.responseApi(requestValid);
    }
    console.log("requestValid.data",requestValid.data);
    let handlerMeth=await handlerVerProducto._handler(requestValid.data);
    return response.responseApi(handlerMeth);
   
  } catch (error) {
    return response.responseApi({
      estado : false,
      mensaje : error
    });
  }
    
});
/**
 
var requestVerProducto = require('../domain/producto/Request/RequestVerProducto');
var handlerVerProducto = require('../domain/producto/Handler/HandlerVerProducto');
 */
module.exports = router;