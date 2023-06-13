require('dotenv').config();
var express = require('express');
var router = express.Router();
const db=require('../db/index');
var jwt = require('jsonwebtoken');
var env = require('../env.json');
var regex = require('../regex.json');
var pdfMet = require('../pdf/pdf-generator');
const util= require('util');
const fs = require('fs');
const moment = require("moment");
var funcionPedidos = require('../models/pedidos');

const query=util.promisify(db.query).bind(db);
router.get('/mostarPedidoPorMesaPdf',async function (req, res) {
  let reqIdPedido=req.query.reqIdPedido=="" || req.query.reqIdPedido==undefined ? "null" : req.query.reqIdPedido;
  let sqlDatosSistema="CALL obtenerdatossistema()";
  let valorResponseDatosSistema=(await  query(sqlDatosSistema))[0][0];
  let sqlDatosPedido="CALL mostrarpedido("+reqIdPedido+")";
  let valorResponsePedido=(await  query(sqlDatosPedido))[0][0];

  let formatDataSistema={
    nombreEmpresa:valorResponseDatosSistema.nombreempresa,
    direccion:valorResponseDatosSistema.direccion,
    telefono:valorResponseDatosSistema.telefono
  };
  let formatDataPedido={
    fecha:valorResponsePedido.fecha,
    idPedido:valorResponsePedido.idpedido,
    mesas:valorResponsePedido.mesas,
    documentoCliente:valorResponsePedido.documentocliente,
    nombreCompletosCliente:valorResponsePedido.nombrecompletoscliente,
    nombreCompletosMozo:valorResponsePedido.nombrecompletosmozo,
    detalle:JSON.parse(valorResponsePedido.detalle)
  };
  let responseBase64=await pdfMet.createPDF({dataSistema : formatDataSistema,
    dataPedido:formatDataPedido});
  return   res.json({
    estado : true,
    dataSistema : formatDataSistema,
    dataPedido:formatDataPedido,
    base64Pdf:responseBase64
  }); 
});

router.get('/cargarPedidoMesa',async function (req, res) {
  try {
    let idMesa=req.query.idMesa=="" || req.query.idMesa==undefined ? "null" : req.query.idMesa;
    let valorResponse=await funcionPedidos.cargarPedidoMesa(idMesa);
    let tempData=[];
    valorResponse[0].forEach(element => {
      tempData.push({
        cantidad:element.cantidad,
        idProducto:element.idproducto,
        nombre:element.nombre,
        precio:element.precio,
        stock:element.stock
      });
    });
    return   res.json({
      estado : true,
      data : tempData
    });
   
   
  } catch (error) {
    console.log("error",error);
    return   res.json({
        estado : false,
        mensaje : error
      });
    }
    
});
router.get('/listadoMesas',async function (req, res) {
  try {
    let reqIdPiso=req.query.idPiso=="" || req.query.idPiso==undefined ? "null" : req.query.idPiso;
    let sql="CALL cargarmesas("+reqIdPiso+")";
    let valorResponse=await  query(sql);
    return   res.json({
      estado : true,
      data : valorResponse[0]
    });
   
   
  } catch (error) {
    console.log("error",error);
    return   res.json({
        estado : false,
        mensaje : error
      });
    }
    
});
router.get('/cargarPiso',async function (req, res) {
  try {
    let sql="CALL listarpiso()";
    let valorResponse=await  query(sql);
    console.log("valorResponse",valorResponse[0]);
    let tempo=[];
    valorResponse[0].forEach(element => {
      tempo.push({
        id:element.idpiso,
        numero:element.numero
      });
    });
    return   res.json({
      estado : true,
      data : tempo
    });
   
   
  } catch (error) {
    console.log("error",error);
    return   res.json({
        estado : false,
        mensaje : error
      });
    }
    
});
router.get('/cargarcategorias',async function (req, res) {
  try {
    let sql="CALL cargarcategorias()";
    let valorResponse=await  query(sql);
    let data=valorResponse[0];
    let dataResponse=[];
    data.forEach(element => {
      dataResponse.push({
        id:element.idcategoria,
        nombre:element.nombre
      });
    });
    return   res.json({
      estado : true,
      data : dataResponse
    });
   
   
  } catch (error) {
    console.log("error",error);
    return   res.json({
        estado : false,
        mensaje : error
      });
    }
    
});

router.get('/cargarTipoDocumento',async function (req, res) {
  try {
    let sql="CALL cargarTipoDocumento()";
    let valorResponse=await  query(sql);
    let data=valorResponse[0];
    let dataResponse=[];
    if(data.length>0){
      data.forEach(element => {
        dataResponse.push({
          id:element.idtipodocumento,
          codigo:element.codigo,
          descripcion:element.descripcion
        });
      });
      return   res.json({
        estado : true,
        data : dataResponse
      });      
    }else{
      return   res.json({
        estado : false,
        mensaje : "No se encontraron datos"
      });   
    }

   
   
  } catch (error) {
    console.log("error",error);
    return   res.json({
        estado : false,
        mensaje : error
      });
    }
    
});
router.get('/cargarProducto',async function (req, res) {
  try {
    let reqIdCategoria=req.query.idCategoria==undefined || req.query.idCategoria=="" ? "null" : req.query.idCategoria;

    let sql="CALL cargarProductos("+reqIdCategoria+")";
    console.log("sql",sql);
    let valorResponse=await  query(sql);
    let data=valorResponse[0];
    let dataResponse=[];
    data.forEach(element => {
      dataResponse.push({
        id:element.idproducto,
        nombre:element.nombre,
        precio:parseFloat(element.precio).toFixed(2),
        esPlato:element.esplato,
        stock:element.stock,
        categoria:element.categoria,
        detalle:element.detalle ? JSON.parse(element.detalle) : []
      });
    });
    return   res.json({
      estado : true,
      data : dataResponse
    });
   
   
  } catch (error) {
    console.log("error",error);
    return   res.json({
        estado : false,
        mensaje : error
      });
    }
    
});
router.get('/cargarIngredientes',async function (req, res) {
  try {

    let sql="CALL listaringredientes()";
    let valorResponse=await  query(sql);
    let data=valorResponse[0];
    let dataResponse=[];
    data.forEach(element => {
      dataResponse.push({
        id:element.idingrediente,
        nombre:element.nombre,
        precio:parseFloat(element.precio).toFixed(2),
        unidadMedida:element.descripcion,
        cantidadStock:element.cantidadstock ? element.cantidadstock  :0 ,
      });
    });
    return   res.json({
      estado : true,
      data : dataResponse
    });
   
   
  } catch (error) {
    console.log("error",error);
    return   res.json({
        estado : false,
        mensaje : error
      });
    }
    
});
router.post('/acceso', async function (req, res) {
  try {
    let body=req.body;
    let correo=body.correo==="" || body.correo===null || body.correo===undefined ? null :body.correo;
    let contrasenia=body.contrasenia==="" || body.contrasenia===null || body.contrasenia===undefined ? null :body.contrasenia;
    
    correo=`'${correo}'`;
    contrasenia=`'${contrasenia}'`;
    let sql="CALL login("+correo+","+contrasenia+")";
    const results =await  query(sql); 
    /*const dataResponse=results.rows;
    let datosSession=dataResponse[0];*/
    let datosSession=results[0][0];
    if(datosSession.estadoflag){
        let token=jwt.sign({
          exp:  (Math.floor(Date.now() / 1000) + env.expiracion),
          data: {
            id:datosSession.idusuario,
            idMozo:datosSession.idmozo,
          }
        }, env.llaveSession);
        return  res.json({
          estado : true,
          mensaje:datosSession.mensaje,
          data:{
            "nombreCompleto":datosSession.nombrecompleto,
            "documentoIdentidad":datosSession.documentoidentidad,
            "idUsuario":datosSession.idusuario
          },
          token:token
        });
    }else{
      return  res.json({
        estado : false,
        mensaje:datosSession.mensaje,
       
      });
    }
      
  } catch (error) {
    console.log(error);
    return res.json({
      estado : false,
      mensaje : error
    });
  }
}); 

router.post('/realizarPedido',async function (req, res) {
  try {
    //let dataPedido=req.body;
    //await db.beginTransaction();
    let token=req.token;
    let body=req.body;
    let valor=await jwt.decode(token,  env.llaveSession);
    let idMozo=valor.data.idMozo;
    let total=valor.data.total;
    let mesas=body.mesas;
    let detallePedido=body.detallePedido;
    let existePedido=await funcionPedidos.cargarPedidoMesa(mesas[0]);
    if(existePedido.length==0){
      let sqlPedido="INSERT INTO `pedido` (`idpedido`, `vigencia`, `total`, `igv`, `estado`, `idcliente`, `idmozo`, `fecha`) VALUES (NULL, '1', '"+total+"', '"+total*0.18+"', 'NUEVO', NULL, '"+idMozo+"', current_timestamp());";
      let valorResponse=await  query(sqlPedido);
      let idPedido=valorResponse.insertId;
      let errorResponse=null;
      mesas.forEach(async(element) => {
        try {
          let sqlPedidoMeza="INSERT INTO `mesapedido` (`idpedido`, `idmesa`) VALUES ('"+idPedido+"','"+element+"');";
          let valorResponseMesas=await  query(sqlPedidoMeza);
          let sqlPedidoActualizarEstado="UPDATE `mesa` SET `estado` = 'OCUPADA' WHERE `mesa`.`idmesa` ="+element+" ;";
          let valorResponseMesasActualizar=await  query(sqlPedidoActualizarEstado);
        } catch (error) {
          console.log("error",error);
          errorResponse=error; 
  
        }
      });
      if(errorResponse){
        return   res.json({
          estado : false,
          mensaje : error
        });
      }
  
  
      detallePedido.forEach(async(element) => {
        try {
        let sqlPedidoDetalle="INSERT INTO `detallepedido` (`cantidad`, `idpedido`, `idproducto`, `preciountario`, `vigencia`) VALUES ('"+element.cantidad+"', '"+idPedido+"', '"+element.id+"', '"+element.precio+"', '1');";
        let valorResponseDetallePedido=await  query(sqlPedidoDetalle);
        let sqlPedidoActualizarPedido="UPDATE `producto` SET stock=stock-"+element.cantidad+"  WHERE `producto`.`idproducto` ="+element.id+";";
        let valorResponseMesasActualizarPedido=await  query(sqlPedidoActualizarPedido);
        } catch (error) {
          console.log("error",error);
          errorResponse=error; 
       }  
      });
      if(errorResponse){
        return   res.json({
          estado : false,
          mensaje : error
        });
      }
      return   res.json({
        estado : true,
        mensaje : "El pedido se realizo con exito"
      });
    }else{
      return   res.json({
        estado : true,
        mensaje : existePedido
      });
    }
    /*let sqlPedido="INSERT INTO `pedido` (`idpedido`, `vigencia`, `total`, `igv`, `estado`, `idcliente`, `idmozo`, `fecha`) VALUES (NULL, '1', '"+total+"', '"+total*0.18+"', 'NUEVO', NULL, '"+idMozo+"', current_timestamp());";
    let valorResponse=await  query(sqlPedido);*/



   
   
  } catch (error) {
    console.log("error",error);
    return   res.json({
        estado : false,
        mensaje : error
      });
    }
    
});

router.post('/cambiarMesa',async function (req, res) {
  try {
    let token=req.token;
    let body=req.body;
    let valor=await jwt.decode(token,  env.llaveSession);
    let desde=body.desde;
    let hasta=body.hasta;
    let sqlPedido="CALL `cambiarMesa`("+desde+","+hasta+");";
    let valorResponse=await  query(sqlPedido);
    return   res.json({
      estado : valorResponse[0][0].estadoflag==1 ? true : false,
      mensaje :valorResponse[0][0].mensaje
    });
   
  } catch (error) {
    console.log("error",error);
    return   res.json({
        estado : false,
        mensaje : error
      });
    }
    
});

router.post('/unirMesas',async function (req, res) {
  try {
    let token=req.token;
    let body=req.body;
    let valor=await jwt.decode(token,  env.llaveSession);
    let desde=body.desde;
    let hasta=body.hasta;
    let sqlPedido="CALL `cambiarMesa`("+desde+","+hasta+");";
    let valorResponse=await  query(sqlPedido);
    return   res.json({
      estado : valorResponse[0][0].estadoflag==1 ? true : false,
      mensaje :valorResponse[0][0].mensaje
    });
   
  } catch (error) {
    console.log("error",error);
    return   res.json({
        estado : false,
        mensaje : error
      });
    }
    
});

router.get('/listarPedidos',async function (req, res) {
  try {
    let sqlPedido="CALL `listarpedidos`();";
    let valorResponse=await  query(sqlPedido);
    let tempPedidos=[];
    if(valorResponse[0].length){
      valorResponse[0].forEach((element) => {
        let detalle=element.detalle ? JSON.parse(element.detalle) : [];
        const array =detalle;
        const key = 'id';

        const arrayUniqueByKey = [...new Map(array.map(item =>
        [item[key], item])).values()];

        tempPedidos.push({
          idPedido:element.idpedido,
          vigencia:element.vigencia,
          total:element.total,
          estado:element.estado,
          idCliente:element.idcliente,
          idMozo:element.idmozo,
          fecha:element.fecha,
          nombreCompleto:element.nombrecompleto,
          mesas:element.numerosmesas,
          detalle:arrayUniqueByKey
        });
       
       
      });
      return   res.json({
        estado :true,
        data :tempPedidos
      });
     
    }else{
      return   res.json({
        estado :false,
        mensaje :"No se encontraron datos"
      });
    }
    
  } catch (error) {
    console.log("error",error);
    return   res.json({
        estado : false,
        mensaje : error
      });
    }
    
});
router.get('/buscarUsuarioCliente',async function (req, res) {
  try {
    let token=req.token;
    let body=req.query;
    let valor=await jwt.decode(token,  env.llaveSession);
    let idTipoCliente=body.idTipoCliente;
    let documento=body.documento;
    let sqlPedido="CALL `buscarcliente`("+idTipoCliente+",'"+documento+"');";
    let valorResponse=await  query(sqlPedido);
    if(valorResponse[0][0].estadoflag){
      let tempDetalles={
        idCliente:valorResponse[0][0].idcliente,
        nombre:valorResponse[0][0].nombre
      };
      return   res.json({
        estado :true,
        data :tempDetalles
      });
     
    }else{
      return   res.json({
        estado :false,
        mensaje :"No se encontraron datos"
      });
    }
    
  } catch (error) {
    console.log("error",error);
    return   res.json({
        estado : false,
        mensaje : error
      });
    }
    
});
router.get('/listarDetallePedido',async function (req, res) {
  try {
    let idPedido=req.query.idPedido;
    let sql="CALL listadetallepedido("+idPedido+")";
    let valorResponse=await  query(sql);
    let data=valorResponse[0];
    let dataResponse=[];
    if(data.length>0){
      data.forEach(element => {
        
        dataResponse.push({
          id:element.idproducto,
          nombre:element.nombre,
          precio:parseFloat(element.preciountario).toFixed(2),
          cantidad:element.cantidad
        });
      });
      return   res.json({
        estado : true,
        data : dataResponse
      });
     
    }else{
      return   res.json({
        estado : false,
        mensaje : "No se encontraron datos"
      });
    }
    
   
  } catch (error) {
    console.log("error",error);
    return   res.json({
        estado : false,
        mensaje : error
      });
    }
    
});
router.get('/buscarCliente',async function (req, res) {
  try {
    let idTipoCliente=req.query.idTipoCliente;
    let documento=req.query.documento;
    let sql="CALL buscarcliente("+idTipoCliente+",'"+documento+"')";
    let valorResponse=await  query(sql);
    let data=valorResponse[0];
    let dataResponse=[];
    if(data[0].estadoflag){
      data.forEach(element => {
        dataResponse.push({
          id:element.idcliente,
          nombre:element.nombre
        });
      });
      return   res.json({
        estado : true,
        data : dataResponse
      });      
    }else{
      return   res.json({
        estado : false,
        mensaje : "No se encontraron datos"
      });   
    }

   
   
  } catch (error) {
    console.log("error",error);
    return   res.json({
        estado : false,
        mensaje : error
      });
    }
    
});
router.post('/realizarCobro',async function (req, res) {
  try {
    let body=req.body;
    let idPedido=body.idPedido;
    let estadoPedido="PAGADO";
    let numeroDocumento=body.numeroDocumento;
    let tipoDocumento=body.tipoDocumento;
    let nombreCliente=body.nombreCliente;
    let sql="CALL realizarpagopedido("+idPedido+",'"+estadoPedido+"','"+numeroDocumento+"',"+tipoDocumento+",'"+nombreCliente+"'"+")";
    let valorResponse=await  query(sql);
    let data=valorResponse[0][0];
    return   res.json({
      estadoflag:data.estadoflag==1 ? true :false,
      mensaje:data.mensaje
    });     

   
   
  } catch (error) {
    console.log("error",error);
    return   res.json({
        estado : false,
        mensaje : error
      });
    }
    
});

router.get('/listadoMesasCocina',async function (req, res) {
  try {
    let sql="CALL pedidosCocina()";
    let valorResponse=await  query(sql);
    let pedidosMesa=valorResponse[0];
    let tempMesaDetalle=[];
    pedidosMesa.forEach(async(element) => {
      let detalle=element.detalle ? JSON.parse(element.detalle) :[];
      const array =detalle;
      const key = 'id';

      const arrayUniqueByKey = [...new Map(array.map(item =>
      [item[key], item])).values()];

        tempMesaDetalle.push({
        mesas:element.numerosmesas,
        mozo:element.nombrecompleto,
        hora:moment(element.fecha).format('HH:mm:ss'),
        fecha:element.fecha,
        
        idPedido:element.idpedido,
        detalle:arrayUniqueByKey
      });
     
    });
    
    return   res.json({
      estado : true,
      data : tempMesaDetalle
    });
    
  } catch (error) {
    console.log("error",error);
    return   res.json({
        estado : false,
        mensaje : error
      });
    }
    
});

router.post('/actualizarEstadoPedido',async function (req, res) {
  try {
    let body=req.body;
    let pedidoPlatoMesaActualizar=body.detalle;
    let estadoPlato=body.estadoPlato;
    await pedidoPlatoMesaActualizar.forEach( async (element) => {
      let idPedido=element.idPedido;
      let idProducto=element.id;
      let sql="UPDATE detallepedido SET estadoplato='"+estadoPlato+"' WHERE idpedido="+idPedido+" and idproducto="+idProducto+";";
      let valorResponse=await  query(sql);
    });
    
    return   res.json({
      estadoflag:true,
      mensaje:"El detalle pedido se actualizo con exito."
    });     

   
   
  } catch (error) {
    console.log("error",error);
    return   res.json({
        estado : false,
        mensaje : error
      });
    }
    
});

router.get('/listarIngredientesProducto',async function (req, res) {
  try {
    let idProducto=req.query.idProducto;
    let sql="CALL listarproductoingredientes("+idProducto+")";
    let valorResponse=await  query(sql);
    let data=valorResponse[0];
    let dataResponse=[];
    if(data.length>0){
      data.forEach(element => {
        dataResponse.push({
          ingrediente:element.nombre,
          idIngrediente:element.idingrediente,
          cantidad:element.cantidad,
          unidadMedida:element.unidadmedida,
        });
      });
      return   res.json({
        estado : true,
        data : dataResponse
      });
     
    }else{
      return   res.json({
        estado : false,
        mensaje : "No se encontraron datos"
      });
    }
    
   
  } catch (error) {
    console.log("error",error);
    return   res.json({
        estado : false,
        mensaje : error
      });
    }
    
});
router.post('/actualizarStockProductos',async function (req, res) {
  try {
    let body=req.body;
    let pedidoPlatoMesaActualizar=body.detalle;
    await pedidoPlatoMesaActualizar.forEach( async (element) => {
      let stock=element.cantidad;
      let idProducto=element.id;
      let sql="UPDATE `producto` SET stock="+stock+"  WHERE idproducto="+idProducto+";";
      console.log("sql",sql);
      let valorResponse=await  query(sql);
    });
    
    return   res.json({
      estadoflag:true,
      mensaje:"Los productos se actualizaron con exito."
    });     

   
   
  } catch (error) {
    console.log("error",error);
    return   res.json({
        estado : false,
        mensaje : error
      });
    }
    
});
module.exports = router;