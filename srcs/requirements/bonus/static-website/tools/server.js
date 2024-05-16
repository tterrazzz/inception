const https = require('https');
const fs = require('fs');
const path = require('path');

const hostname = '0.0.0.0';
const port = 443;

const options = {
	key: fs.readFileSync(path.join(__dirname, 'certs', 'avan-selfsigned.key')),
	cert: fs.readFileSync(path.join(__dirname, 'certs', 'avan-selfsigned.pem'))
};

const filePath = path.join(__dirname, 'index.html');

https.createServer(options, (req, res) => {
	fs.readFile(filePath, (error, content) => {
		if (error) {
			res.writeHead(500);
			res.end('Error: ${error.code} Bad Server Response\n');
		} else {
			res.writeHead(200, { 'Content-Type': 'test/html'});
			res.end(content, 'utf-8');
		}
	});
}).listen(port, hostname, () => {
	console.log('Server running at https://${hostname}:${port}/');
});
