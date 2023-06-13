require('dotenv').config();
var express = require('express');
var handlerCategoria = require('../domain/categoria/Handler/HandlerListarCategoria');
var handlerCargarCategoria = require('../domain/categoria/Handler/HandlerCargarCategoria');
var requestRegistrarCategoria = require('../domain/categoria/Request/RequestRegistrarCategoria');
var handlerRegistrarCategoria = require('../domain/categoria/Handler/HandlerRegistrarCategoria');

var requestActualizarCategoria = require('../domain/categoria/Request/RequestActualizaCategoria');
var handlerActualizarCategoria = require('../domain/categoria/Handler/HandlerActualizarCategoria');

var requestEliminarCategoria = require('../domain/categoria/Request/RequestEliminarCategoria');
var handlerEliminarCategoria = require('../domain/categoria/Handler/HandlerEliminarCategoria');

var response = require('../response/index');
var router = express.Router();
router.get('/listarCategoriaGeneral',async function (req, res) {
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
router.post('/nuevoCategoria',async function (req, res) {
  try {
    let requestValid=await requestRegistrarCategoria.esValido(req);
    if(!requestValid.estado){
      return response.responseApi(requestValid);
    }
    let handlerMeth=await handlerRegistrarCategoria._handler(requestValid.data);
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
router.delete('/eliminarCategoria',async function (req, res) {
  try {
    let requestValid=await requestEliminarCategoria.esValido(req);
    if(!requestValid.estado){
      return response.responseApi(requestValid);
    }
    let handlerMeth=await handlerEliminarCategoria._handler(requestValid.data);
    return response.responseApi(handlerMeth);
   
  } catch (error) {
    return response.responseApi({
      estado : false,
      mensaje : error
    });
  }
    
});
router.get('/cargarCategoriaGeneral',async function (req, res) {
  try {
    let handlerMeth=await handlerCargarCategoria._handler({});
    return response.responseApi(handlerMeth);
   
  } catch (error) {
    return response.responseApi({
      estado : false,
      mensaje : error
    });
    
  }
    
});
module.exports = router;