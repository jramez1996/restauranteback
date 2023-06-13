var express = require('express');
var app = express();
var url = require('url');
var validate = require('uuid-validate');
const bodyParser = require('body-parser');
const bearerToken = require('express-bearer-token');
const appHttp = require('http').createServer(app)
const io = require('socket.io')(appHttp);
const ventas=require("./router/ventas");
const clientes=require("./router/clientes");
const productos=require("./router/productos");
const proveedor=require("./router/proveedor");
const compras=require("./router/compras");
const seguridad=require("./router/seguridad");
const global=require("./router/global");
const pedidos=require("./router/pedidos");
const tiendas=require("./router/tiendas");
const categorias=require("./router/categorias");
const tipoproducto=require("./router/tipoproducto");
const marcas=require("./router/marcas");
const unidadmedida=require("./router/unidadmedida");
var jwt = require('jsonwebtoken');
var env = require('./env.json');
app.use(bearerToken());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json({limit: '25mb'}));
app.use(bodyParser.raw({limit: '25mb'}));
const { Client } = require('pg');
app.set('port', process.env.PORT || 3000);
app.set('llaveSession', 'llaveSession');
const cors = require('cors');
app.use(cors());
app.options('*', cors());
app.use("/public",express.static('public'));


/*
    user: 'postgres',
    host: 'localhost',
    database: 'miecommers',
    password: 'admin',
    port: 5432, */
const connectionData = {
  user: 'postgres',
  host: 'localhost',
  database: 'miecommers',
  password: 'admin',
  port: 5432,
}
const client = new Client(connectionData)
client.connect();
app.get('/test', async function (req, res) {
 try {
  const result=await client.query('SELECT * FROM producto')
  console.log("result",result);
    
 } catch (error) {
   console.log("error",error);
 }
 /* .then(response => {
      console.log("HOLA :",response.rows)
      client.end()
  })
  .catch(err => {
    console.log("error",err);
    client.end()
  })*/
  var data = {
    "Fruits": [
      "apple",
      "orange"    ]
  };
 return res.json(data);
});


appHttp.listen(app.get("port"), function(){
  console.log('Server Express soooooooooooooooooooo!');
});