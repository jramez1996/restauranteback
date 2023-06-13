require('dotenv').config();
var express = require('express');
var handlerIngrediente = require('../domain/Ingrediente/Handler/HandlerListarIngrediente');

var HandlerCargarIngrediente = require('../domain/Ingrediente/Handler/HandlerCargarIngrediente');

var requestRegistrarIngrediente = require('../domain/Ingrediente/Request/RequestRegistrarIngrediente');
var handlerRegistrarIngrediente = require('../domain/Ingrediente/Handler/HandlerRegistrarIngrediente');

var requestEliminarIngrediente = require('../domain/Ingrediente/Request/RequestEliminarIngrediente');
var handlerEliminarIngrediente =        require('../domain/Ingrediente/Handler/HandlerEliminarIngrediente');

var requestActualizarIngrediente = require('../domain/Ingrediente/Request/RequestActualizarIngrediente');
var handlerActualizarIngrediente = require('../domain/Ingrediente/Handler/HandlerActualizarIngrediente');
var response = require('../response/index');
var router = express.Router();
router.get('/listarIngredienteGeneral',async function (req, res) {
  try {
    let handlerMeth=await handlerIngrediente._handler({});
    return response.responseApi(handlerMeth);
   
  } catch (error) {
    console.log("error",error);
    return   res.json({
        estado : false,
        mensaje : error
      });
    }
    
});
router.post('/nuevoIngrediente',async function (req, res) {
  try {
    let requestValid=await requestRegistrarIngrediente.esValido(req);
    if(!requestValid.estado){
      return response.responseApi(requestValid);
    }
    let handlerMeth=await handlerRegistrarIngrediente._handler(requestValid.data);
    return response.responseApi(handlerMeth);
   
  } catch (error) {
    console.log("error",error);
    return   res.json({
        estado : false,
        mensaje : error
      });
    }
    
});
router.put('/actualizarIngrediente',async function (req, res) {
  try {
   
    let requestValid=await requestActualizarIngrediente.esValido(req);
  
    if(!requestValid.estado){
      return response.responseApi(requestValid);
    }
    let handlerMeth=await handlerActualizarIngrediente._handler(requestValid.data);
    return response.responseApi(handlerMeth);
   
  } catch (error) {
    console.log("error",error);
    return   res.json({
        estado : false,
        mensaje : error
      });
    }
    
});
router.get('/cargarIngrediente',async function (req, res) {
  try {
    let handlerMeth=await HandlerCargarIngrediente._handler({});
    return response.responseApi(handlerMeth);
   
  } catch (error) {
    console.log("error",error);
    return   res.json({
        estado : false,
        mensaje : error
      });
    }
    
});
router.delete('/eliminarIngrediente',async function (req, res) {
  try {
    let requestValid=await requestEliminarIngrediente.esValido(req);
    if(!requestValid.estado){
      return response.responseApi(requestValid);
    }
    let handlerMeth=await handlerEliminarIngrediente._handler(requestValid.data);
    return response.responseApi(handlerMeth);
   
  } catch (error) {
    return response.responseApi(error);
  }
    
});
module.exports = router;