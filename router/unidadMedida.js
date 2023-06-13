require('dotenv').config();
var express = require('express');
var handlerUnidadMedida = require('../domain/UnidadMedida/Handler/HandlerListarUnidadMedida');
var handlerCargarUnidadMedida = require('../domain/UnidadMedida/Handler/HandlerCargarUnidadMedida');

var requestRegistrarUnidadMedida = require('../domain/UnidadMedida/Request/RequestRegistrarUnidadMedida');
var handlerRegistrarUnidadMedida = require('../domain/UnidadMedida/Handler/HandlerRegistrarUnidadMedida');

var requestActualizarUnidadMedida = require('../domain/UnidadMedida/Request/RequestActualizarUnidadMedida');
var handlerActualizarUnidadMedida = require('../domain/UnidadMedida/Handler/HandlerActualizarUnidadMedida');
var response = require('../response/index');

var requestEliminarUnidadMedida = require('../domain/UnidadMedida/Request/RequestEliminarUnidadMedida');
var handlerEliminarUnidadMedida = require('../domain/UnidadMedida/Handler/HandlerEliminarMesa');
var router = express.Router();
router.get('/listarUnidadMedidaGeneral',async function (req, res) {
  try {
    let handlerMeth=await handlerUnidadMedida._handler({});
    return response.responseApi(handlerMeth);
   
  } catch (error) {
    console.log("error",error);
    return   res.json({
        estado : false,
        mensaje : error
      });
    }
    
});

router.post('/nuevoUnidadMedida',async function (req, res) {
  try {
    let requestValid=await requestRegistrarUnidadMedida.esValido(req);
    if(!requestValid.estado){
      return response.responseApi(requestValid);
    }
    let handlerMeth=await handlerRegistrarUnidadMedida._handler(requestValid.data);
    return response.responseApi(handlerMeth);
   
  } catch (error) {
    console.log("error",error);
    return   res.json({
        estado : false,
        mensaje : error
      });
    }
    
});
router.put('/actualizarUnidadMedida',async function (req, res) {
  try {
   
    let requestValid=await requestActualizarUnidadMedida.esValido(req);
  
    if(!requestValid.estado){
      return response.responseApi(requestValid);
    }
    let handlerMeth=await handlerActualizarUnidadMedida._handler(requestValid.data);
    return response.responseApi(handlerMeth);
   
  } catch (error) {
    console.log("error",error);
    return   res.json({
        estado : false,
        mensaje : error
      });
    }
    
});
router.delete('/eliminarUnidadMedida',async function (req, res) {
  try {
    let requestValid=await requestEliminarUnidadMedida.esValido(req);
    if(!requestValid.estado){
      return response.responseApi(requestValid);
    }
    let handlerMeth=await handlerEliminarUnidadMedida._handler(requestValid.data);
    return response.responseApi(handlerMeth);
   
  } catch (error) {
    return response.responseApi({
      estado : false,
      mensaje : error
    });
  }
    
});
router.get('/cargarUnidadMedida',async function (req, res) {
  try {
    let handlerMeth=await handlerCargarUnidadMedida._handler({});
    return response.responseApi(handlerMeth);
   
  } catch (error) {
    console.log("error",error);
    return   res.json({
        estado : false,
        mensaje : error
      });
    }
    
});
module.exports = router;