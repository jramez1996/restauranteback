var express = require('express');
var app = express();
const bodyParser = require('body-parser');
const acceso = require('./acceso');
const bearerToken = require('express-bearer-token');
const appHttp = require('http').createServer(app)
const gasto=require("./router/gasto");
const mesas=require("./router/mesas");
const categoria=require("./router/categoria");
const tipoPago=require("./router/tipoPago");
const producto=require("./router/productos");
const ingredientes=require("./router/ingredientes");
const productoIngrediente=require("./router/productoIngrediente");
const unidadMedida=require("./router/unidadMedida");
const mesas1=require("./router/mesas1");
const pedidos=require("./router/pedidos");
const piso=require("./router/piso");
const global=require("./global/index.json");
const globalMetho=require("./global/global.js");
const response=require("./response/index");
const usuario=require("./router/usuario");
const ubigeo=require("./router/ubigeo");
const ventas=require("./router/ventas");
const reportes=require("./router/reportes");
const cors = require('cors');
app.use(bearerToken());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json({limit: '250mb'}));
app.use(bodyParser.raw({limit: '250mb'}));
app.set('port', process.env.PORT || 3000);
app.set('llaveSession', 'llaveSession');
app.use(cors());
app.options('*', cors()); //verProducto
app.use("/public",express.static('public'));
app.use(express.static('img'));
app.use(async function(req, res, next) {
  global.request=req;
  global.response=res;
  let jwtValid= acceso.jwt.filter( (value)=>{
     console.log(((value.type==req.method && req._parsedUrl.pathname==value.ruta)));
     if(value.type==req.method && req._parsedUrl.pathname==value.ruta){
          return   !(globalMetho.toAutenticado());
     }
     return  false;
  });
  if(jwtValid.length){
      return response.responseApi({
        estado:false,
        codigoError:"NOTAUTH",
        mensaje:"Permiso no permitido."
      });
  }
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
next();
});

app.use(async function(req, res, next) {
  global.request=req;
  global.response=res;

  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
next();
});
app.use('/mesas1',mesas1);
app.use('/mesas',mesas);
app.use('/pedidos',pedidos);
app.use('/pisos',piso);
app.use('/unidadMedida',unidadMedida);
app.use('/categoria',categoria);
app.use('/productos',producto);
app.use('/ingredientes',ingredientes);
app.use('/productoIngrediente',productoIngrediente);
app.use('/tipoPagos',tipoPago);
app.use('/gastos',gasto);
app.use('/usuarios',usuario);
app.use('/ubigeos',ubigeo);
app.use('/ventas',ventas);
app.use('/reportes',reportes);
appHttp.listen(app.get("port"), function(){
  console.log('Server  Ready!');
});