const db=require('../db/index');
const util= require('util');
const global=require('../global/index.json');
module.exports = {
	async responseApi(data) {
        return global.response.json(data);  
	}
}