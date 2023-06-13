require('dotenv').config();
var express = require('express');

var response = require('../response/index');
var requestListarProductoIngrediente = require('../domain/productoIngrediente/Request/RequestListarProductoIngrediente');
var handlerListarProductoIngrediente = require('../domain/productoIngrediente/Handler/HandlerListarProductoIngrediente');

var requestAsignarIngredienteProducto = require('../domain/productoIngrediente/Request/RequestAsignarIngredienteProducto');
var handlerAsignarIngredienteProducto = require('../domain/productoIngrediente/Handler/HandlerAsignarIngredienteProducto');

var router = express.Router();
router.get('/listarProductoIngredientes',async function (req, res) {
  try {
    let requestValid=await requestListarProductoIngrediente.esValido(req);
    if(!requestValid.estado){
      return response.responseApi(requestValid);
    }
    let handlerMeth=await handlerListarProductoIngrediente._handler(requestValid.data);
    return response.responseApi(handlerMeth);
   
  } catch (error) {
    return response.responseApi({
      estado : false,
      mensaje : error
    });
  }
    
});
router.post('/asignarProductoIngredientes',async function (req, res) {
  try {
    let requestValid=await requestAsignarIngredienteProducto.esValido(req);
    if(!requestValid.estado){
      return response.responseApi(requestValid);
    }
    let handlerMeth=await handlerAsignarIngredienteProducto._handler(requestValid.data);
    return response.responseApi(handlerMeth);
   
  } catch (error) {
    console.log("error",error);
    return response.responseApi({
      estado : false,
      mensaje : error
    });
  }
    
});

module.exports = router;