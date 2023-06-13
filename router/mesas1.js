require('dotenv').config();
var express = require('express');
var handlerMesa = require('../domain/mesa/Handler/HandlerListarMesa');

var requestRegistrarMesa = require('../domain/mesa/Request/RequestRegistrarMesa');
var handlerRegistrarMesa = require('../domain/mesa/Handler/HandlerRegistrarMesa');

var requestActualizarMesa = require('../domain/Mesa/Request/RequestActualizarMesa');
var handlerActualizarMesa = require('../domain/Mesa/Handler/HandlerActualizarMesa');


var requestEliminarMesa = require('../domain/Mesa/Request/RequestEliminarMesa');
var handlerEliminarMesa = require('../domain/Mesa/Handler/HandlerEliminarMesa');

var response = require('../response/index');
var router = express.Router();
router.get('/listarMesasGeneral',async function (req, res) {
  try {
    let handlerMeth=await handlerMesa._handler({});
    return response.responseApi(handlerMeth);
   
  } catch (error) {
    console.log("error",error);
    return   res.json({
        estado : false,
        mensaje : error
      });
    }
    
});

router.post('/nuevoMesa',async function (req, res) {
  try {
    let requestValid=await requestRegistrarMesa.esValido(req);
    if(!requestValid.estado){
      return response.responseApi(requestValid);
    }
    let handlerMeth=await handlerRegistrarMesa._handler(requestValid.data);
    return response.responseApi(handlerMeth);
   
  } catch (error) {
    console.log("error",error);
    return   res.json({
        estado : false,
        mensaje : error
      });
    }
    
});
router.put('/actualizarMesa',async function (req, res) {
  try {
    let requestValid=await requestActualizarMesa.esValido(req);
  
    if(!requestValid.estado){
      return response.responseApi(requestValid);
    }
    let handlerMeth=await handlerActualizarMesa._handler(requestValid.data);
    return response.responseApi(handlerMeth);
   
  } catch (error) {
    console.log("error",error);
    return   res.json({
        estado : false,
        mensaje : error
      });
    }
    
});
router.delete('/eliminarMesa',async function (req, res) {
  try {
    let requestValid=await requestEliminarMesa.esValido(req);
    if(!requestValid.estado){
      return response.responseApi(requestValid);
    }
    let handlerMeth=await handlerEliminarMesa._handler(requestValid.data);
    return response.responseApi(handlerMeth);
   
  } catch (error) {
    return response.responseApi({
      estado : false,
      mensaje : error
    });
  }
    
});
module.exports = router;