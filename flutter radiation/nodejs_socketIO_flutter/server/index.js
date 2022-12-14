const app = require('express')();
const server = require('http').createServer(app);
const options = { /* ... */ };
const io = require('socket.io')(server, options);
const port = 3484;

io.on('connection', socket => { console.log('New client connect');});

server.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
});