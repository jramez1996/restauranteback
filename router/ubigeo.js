require('dotenv').config();
var express = require('express');
var requestCargarUbigeo = require('../domain/ubigeo/Request/RequestCargarUbigeo');
var handlerCargarUbigeo = require('../domain/ubigeo/Handler/HandlerCargarUbigeo');

var response = require('../response/index');
var router = express.Router();

router.get('/cargarUbigeos',async function (req, res) {
    try {
        let requestValid=await requestCargarUbigeo.esValido(req);

        console.log("hoaaaaaaaaaaaaaaaa",requestValid);
        if(!requestValid.estado){
          return response.responseApi(requestValid);
        }

        let handlerMeth=await handlerCargarUbigeo._handler(requestValid.data);
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