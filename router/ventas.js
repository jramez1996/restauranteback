require('dotenv').config();
var express = require('express');
var requestListarVentas = require('../domain/ventas/Request/RequestListarVentas');
var handlerListarVentas = require('../domain/ventas/Handler/HandlerListarVentas');

var response = require('../response/index');
var router = express.Router();


router.get('/listarVentas',async function (req, res) {
  try {
    let requestValid=await requestListarVentas.esValido(req);
    if(!requestValid.estado){
      return response.responseApi(requestValid);
    }
    let handlerMeth=await handlerListarVentas._handler(requestValid.data);
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