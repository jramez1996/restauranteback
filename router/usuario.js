require('dotenv').config();
var express = require('express');
const db=require('../db/index');
const util= require('util');
const query=util.promisify(db.query).bind(db);
/*var handlerIngrediente = require('../domain/Ingrediente/Handler/HandlerListarIngrediente');
var HandlerCargarIngrediente = require('../domain/Ingrediente/Handler/HandlerCargarIngrediente');

var requestEliminarIngrediente = require('../domain/Ingrediente/Request/RequestEliminarIngrediente');
var handlerEliminarIngrediente =        require('../domain/Ingrediente/Handler/HandlerEliminarIngrediente');
*/
var requestRegistrarUsuarioMozo = require('../domain/usuario/Request/RequestRegistrarUsuarioMozo');
var handlerRegistrarUsuarioMozo = require('../domain/usuario/Handler/HandlerRegistrarUsuarioMozo');

var requestActualizaUsuarioMozo = require('../domain/usuario/Request/RequestActualizaUsuarioMozo');
var handlerActualizarUsuarioMozo = require('../domain/usuario/Handler/HandlerActualizarUsuarioMozo');

//var requestListarUsuarioMozo = require('../domain/usuario/Request/RequestListarUsuarioMozo');
var handlerListarUsuarioMozo = require('../domain/usuario/Handler/HandlerListarUsuarioMozo');
const axios = require('axios');
var response = require('../response/index');
var router = express.Router();
/*

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
    
});*/
router.post('/nuevoUsuario',async function (req, res) {
  try {
    let requestValid=await requestRegistrarUsuarioMozo.esValido(req);
    if(!requestValid.estado){
      return response.responseApi(requestValid);
    }
    let handlerMeth=await handlerRegistrarUsuarioMozo._handler(requestValid.data);
    return response.responseApi(handlerMeth);
   
  } catch (error) {
    console.log("error",error);
    return response.responseApi(error);
  }
    
});

router.put('/actualizarUsuario',async function (req, res) {
  try {
    let requestValid=await requestActualizaUsuarioMozo.esValido(req);
  
    if(!requestValid.estado){
      return response.responseApi(requestValid);
    }
    let handlerMeth=await handlerActualizarUsuarioMozo._handler(requestValid.data);
    return response.responseApi(handlerMeth);
   
  } catch (error) {
    console.log("error",error);
    return response.responseApi(error);
  }
    
});
router.get('/listarUsuario',async function (req, res) {
  try {
    let handlerMeth=await handlerListarUsuarioMozo._handler({});
    return response.responseApi(handlerMeth);
   
  } catch (error) {
    return response.responseApi(error);
    }
    
});
router.get('/registrarCiudades',async function (req, res) {
  try {
    /*let data=await axios.get('https://raw.githubusercontent.com/ernestorivero/Ubigeo-Peru/master/json/ubigeo_peru_2016_departamentos.json');
    data.data.forEach(async(dat)=>{
      console.log("data",dat);
      let sqlFomat="INSERT INTO `ubigeo` (`idubigeo`, `codigoubigeo`, `descripcion`, `codigoubigeopadre`, `nivel`) VALUES (NULL, '"+dat.id+"', '"+dat.name+"',null, '1');";
      //console.log(sqlFomat);
      //let responseProce=await db.select(sqlFomat,{}); 
      let dbPedido=await query(sqlFomat);
    });*/
    /*
    let data=await axios.get('https://raw.githubusercontent.com/ernestorivero/Ubigeo-Peru/master/json/ubigeo_peru_2016_provincias.json');
    data.data.forEach(async(dat)=>{
      console.log("data",dat);
      let sqlFomat="INSERT INTO `ubigeo` (`idubigeo`, `codigoubigeo`, `descripcion`, `codigoubigeopadre`, `nivel`) VALUES (NULL, '"+dat.id+"', '"+dat.name+"',"+dat.department_id+", '2');";
      //console.log(sqlFomat);
      //let responseProce=await db.select(sqlFomat,{}); 
      let dbPedido=await query(sqlFomat);
    });*/
    
    let data=await axios.get('https://raw.githubusercontent.com/ernestorivero/Ubigeo-Peru/master/json/ubigeo_peru_2016_distritos.json');
    data.data.forEach(async(dat)=>{
      console.log("data",dat);
      let sqlFomat="INSERT INTO `ubigeo` (`idubigeo`, `codigoubigeo`, `descripcion`, `codigoubigeopadre`, `nivel`) VALUES (NULL, '"+dat.id+"', '"+dat.name+"',"+dat.province_id+", '3');";
      //console.log(sqlFomat);
      //let responseProce=await db.select(sqlFomat,{}); 
      let dbPedido=await query(sqlFomat);
    });
    return response.responseApi("data");
   
  } catch (error) {
    return response.responseApi(error);
    }
    
});
module.exports = router;