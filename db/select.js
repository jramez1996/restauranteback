const db=require('./index');
const util= require('util');
const query=util.promisify(db.query).bind(db);
module.exports = {
	async select(sql,valorKey=null) {
        let sqlFormat=sql ;

        let tempKeySinFormat=sqlFormat.split("(")[1].split(")")[0].split(",");
        let sqlVlores=sqlFormat;
     
        if(valorKey==null){
          let dbPedido=await query(sql);
          return dbPedido;
        }else{
          
          for (let index = 0; index < tempKeySinFormat.length; index++) {
        
            //tempKey.push(tempKeySinFormat[index].trim());
            let valorDatos=valorKey[tempKeySinFormat[index].trim()];
            if(typeof valorKey[tempKeySinFormat[index].trim()] === 'string' ){
              valorDatos="'"+valorKey[tempKeySinFormat[index].trim()]+"'";
            }else{
              
              if(typeof valorKey[tempKeySinFormat[index].trim()] === 'boolean' ){
                valorDatos=valorKey[tempKeySinFormat[index].trim()] ? "true" : "false";
              }else{
                valorDatos=valorKey[tempKeySinFormat[index].trim()];
              }
             
            }
            sqlVlores=sqlVlores.replace(tempKeySinFormat[index].trim(),valorDatos);

          } 
          //console.log("valorKey",valorKey);
          console.log("funcion",sqlVlores);

          let dbPedido=await query(sqlVlores);
          return dbPedido;
        }

        
	}
}