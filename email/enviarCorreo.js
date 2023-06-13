var nodemailer = require('nodemailer');
var hbs = require('nodemailer-express-handlebars');
path = require('path'),
    config = require('../env.json');
let mailer = nodemailer.createTransport({
    host: "smtp.gmail.com",
    port: 587,
    secure: false, // upgrade later with STARTTLS
    auth: {
        user: "ariesjuan1996@gmail.com",
        pass: "bebecita666@",
    }
});


module.exports = {
        async enviarCorreo(data) {
         
            try {
                // console.log(data.vista);
                console.log(data.vista + '.hbs');
                var options = {
                    viewEngine: {
                        extName: '.hbs',
                        partialsDir: 'email/html',
                        layoutsDir: 'email/html',
                        defaultLayout: data.vista + '.hbs',
                    },
                    viewPath: 'email/html',
                    extName: '.hbs',
                };
                mailer.use('compile', hbs(options));
                //console.log(data.data);
                let rpta = await mailer.sendMail({
                    template: data.vista,
                    to: data.correo,
                    subject: data.tema,
                    context: data.data
                });
                return rpta;
            } catch (error) {
                //console.log(error);
                return error;

                //return error;      
            }
            //return "ij"; 
        }
    }
    /*
    async function  enviarcorreo(data){
        mailer.sendMail({
              template: data.vista,
              to: data.correo,
              subject:data.tema,
              context:data.data
            },function(err,response){
                if(err){
                    console.log(err);
                }
                console.log("naan");
            });
    }

    let rptamsg=enviarcorreo({
        vista:"expiracioncontrasenia",
        correo:"jramirez.leoncito@gmail.com",
        tema:"jramirez.leoncito@gmail.com",
        data:{
            empresa:"NETWORK WORK",
            usuario:"juan ramirez"
        }
    });*/
