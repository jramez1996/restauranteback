var jwt = require('jsonwebtoken');
var env = require('../env.json');
var sizeOf = require('buffer-image-size');
const xl = require('excel4node');
const fs = require('fs');
const axios = require('axios');
var globalrequest =     require('./index.json');
const toUrlHostServer=async (req)=>{
	var fullUrl = req.protocol + '://' + req.get('Host');
	return fullUrl;
}
const toIdMozo=async ()=>{
	var token = await globalrequest.request.token ;
	let valor=await jwt.decode(token,  env.llaveSession);
    let idMozo=valor.data.idMozo==undefined ? false : valor.data.idMozo;
	return idMozo;
}
const toIdUsuario=async ()=>{
	var token = await globalrequest.request.token ;
	let valor=await jwt.decode(token,  env.llaveSession);
    let id=valor.data.id==undefined ? false :valor.data.id;
	return id;
}
const toAutenticado=async ()=>{
	try {
		var token = globalrequest.request.token ;
		let valor=jwt.decode(token,  env.llaveSession);
		console.log("si",(valor));
		return valor==null ? false : true;		
	} catch (error) {
		return false;
	}

	
}
module.exports = {toUrlHostServer,toIdMozo,toIdUsuario,toAutenticado};