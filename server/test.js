const WebSocket = require('ws');
 
const ws = new WebSocket('ws://localhost:3000/api/poller/', {
  perMessageDeflate: false
});

ws.on('open', function open() {
    ws.send('something');
  });
   
  ws.on('message', function incoming(data) {
    console.log("Recived: " + data);
  });