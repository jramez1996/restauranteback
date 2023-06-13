const fs = require("fs");
const path = require("path");
const puppeteer = require('puppeteer');
const handlebars = require("handlebars");
const moment = require("moment");
async function createPDF(data){

	var templateHtml = fs.readFileSync(path.join(process.cwd(), './pdf/precuenta.html'), 'utf8');
	var template = handlebars.compile(templateHtml);
	var html = template(data);

	var milis = new Date();
	milis = milis.getTime();

	var pdfPath =`./pdf/tmp/${data.name}-${milis}.pdf`;

	var options = {
		//width: '250px',
		format: 'a6', 
		headerTemplate: "<p></p>",
		footerTemplate: "<p></p>",
		displayHeaderFooter: false,
		margin: {
			top: "10px",
			bottom: "30px"
		},
		printBackground: true,
		path: pdfPath
	}

	const browser = await puppeteer.launch({
		args: ['--no-sandbox'],
		headless: true
	});

	var page = await browser.newPage();
	
	await page.goto(`data:text/html;charset=UTF-8,${html}`, {
		waitUntil: 'networkidle0'
	});
	//await page.pdf({ path: 'hn.pdf',  });
	await page.pdf(options);

	const pdf2base64 = require('pdf-to-base64');


	await browser.close();
	let fileBase64= ("data:application/pdf;base64,"+ await pdf2base64(pdfPath));
	fs.unlinkSync(pdfPath);
    return fileBase64;
}
module.exports = {
	async createPDF(data) {
		data.dataPedido.fechaImpresion=moment().format('DD/MM/YYYY HH:mm:ss');
		return createPDF({
			name: "remesa",
			dataSistema:data.dataSistema,
			dataPedido:data.dataPedido
		});
	}
}