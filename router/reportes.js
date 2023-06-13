require('dotenv').config();
var express = require('express');
var handlerReportePrincipal = require('../domain/reporte/Handler/HandlerReportePrincipal');

var response = require('../response/index');
var router = express.Router();


router.get('/reporteDashboard',async function (req, res) {
  try {
    let handlerMeth=await handlerReportePrincipal._handler({});
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