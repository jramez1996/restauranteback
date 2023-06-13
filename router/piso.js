require('dotenv').config();
var express = require('express');
var handlerPiso = require('../domain/piso/Handler/HandlerListarPiso');
var HandlerCargarPiso = require('../domain/piso/Handler/HandlerCargarPiso');
var requestRegistrarPiso = require('../domain/piso/Request/RequestRegistrarPiso');
var handlerRegistrarPiso = require('../domain/piso/Handler/HandlerRegistrarPiso');

var requestActualizarPiso = require('../domain/piso/Request/RequestActualizarPiso');
var handlerActualizarPiso = require('../domain/piso/Handler/HandlerActualizarPiso');

var requestEliminarPiso = require('../domain/piso/Request/RequestEliminarPiso');
var handlerEliminarPiso = require('../domain/piso/Handler/HandlerEliminarPiso');

var response = require('../response/index');
var router = express.Router();
router.get('/listarPisosGeneral',async function (req, res) {
  try {
    let handlerMeth=await handlerPiso._handler({});
    return response.responseApi(handlerMeth);
   
  } catch (error) {
    console.log("error",error);
    return   res.json({
        estado : false,
        mensaje : error
      });
    }
    
});

router.post('/nuevoPiso',async function (req, res) {
  try {
    let requestValid=await requestRegistrarPiso.esValido(req);
    if(!requestValid.estado){
      return response.responseApi(requestValid);
    }
    let handlerMeth=await handlerRegistrarPiso._handler(requestValid.data);
    return response.responseApi(handlerMeth);
   
  } catch (error) {
    console.log("error",error);
    return   res.json({
        estado : false,
        mensaje : error
      });
    }
    
});
router.put('/actualizarPiso',async function (req, res) {
  try {
   
    let requestValid=await requestActualizarPiso.esValido(req);
  
    if(!requestValid.estado){
      return response.responseApi(requestValid);
    }
    let handlerMeth=await handlerActualizarPiso._handler(requestValid.data);
    return response.responseApi(handlerMeth);
   
  } catch (error) {
    console.log("error",error);
    return   res.json({
        estado : false,
        mensaje : error
      });
    }
    
});
router.delete('/eliminarPiso',async function (req, res) {
  try {
   
    let requestValid=await requestEliminarPiso.esValido(req);
  
    if(!requestValid.estado){
      return response.responseApi(requestValid);
    }
    let handlerMeth=await handlerEliminarPiso._handler(requestValid.data);
    return response.responseApi(handlerMeth);
   
  } catch (error) {
    return response.responseApi({
      estado : false,
      mensaje : error
    });
  }
    
});
router.get('/cargarPisoGeneral',async function (req, res) {
  try {
    let handlerMeth=await HandlerCargarPiso._handler({});
    return response.responseApi(handlerMeth);
   
  } catch (error) {
    return response.responseApi({
      estado : false,
      mensaje : error
    });

    }
    
});
module.exports = router;