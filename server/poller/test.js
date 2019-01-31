const IP_SNMPSIM = "172.21.0.2"

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


template_oid = [
  {"table_name":"if_x_table","oid":"1.3.6.1.2.1.31.1.1","mib":null,"cols":[1,18],"format":{},"type":"table","oid_id":1},
  {"table_name":"if_table","oid":"1.3.6.1.2.1.2.2","mib":null,"cols":[1,2,4,5,7,8],"format":{},"type":"table","oid_id":2},
  {"table_name":"cisco_cdp_cache_table","oid":"1.3.6.1.4.1.9.9.23.1.2.1","mib":null,"cols":[1,3,4,5,6,7,8,9,10,11,12],"format":{"2":"formats.ipAddress"},"type":"table","oid_id":3},
  {"table_name":"ospf_nbr_table","oid":"1.3.6.1.2.1.14.10","mib":null,"cols":[1,2,3,4,5,6,7,8,9,10,11],"format":{},"type":"table","oid_id":4},
  {"table_name":"sys_descr","oid":"1.3.6.1.2.1.1.1.0","mib":null,"cols":null,"format":{},"type":"single","oid_id":5},
  {"table_name":"sys_name","oid":"1.3.6.1.2.1.1.5.0","mib":null,"cols":null,"format":{},"type":"single","oid_id":6},
  {"table_name":"bgp_peer_table","oid":"1.3.6.1.2.1.15.3","mib":null,"cols":[1,2],"format":{},"type":"table","oid_id":7}
  ]


const bodyStart = {
  action: "start",
  project: 1,
  options:{clean:true},
  hosts: [
    {"host_id":3,"alias":"R2","community":"R2","ip_address":IP_SNMPSIM,"port":1024,"location":"testbench","template_oid": template_oid },
    {"host_id":4,"alias":"R3","community":"R3","ip_address":IP_SNMPSIM,"port":1024,"location":"testbench","template_oid": template_oid },
    {"host_id":5,"alias":"R4","community":"R4","ip_address":IP_SNMPSIM,"port":1024,"location":"testbench","template_oid": template_oid },
    {"host_id":6,"alias":"R5","community":"R5","ip_address":IP_SNMPSIM,"port":1024,"location":"testbench","template_oid": template_oid },
    {"host_id":1,"alias":"tout","community":"tout","ip_address":IP_SNMPSIM,"port":1024,"location":"testbench","template_oid": template_oid }
  ]
}

/*
const bodyStart = {
  action: "start",
  project: 1,
  options:
  {clean:true},
  hosts: [
    {"alias":"R1","community":"R1","ip_address":IP_SNMPSIM,"port":1024,"location":"testbench","template_oid": template_oid }
  ]
}
*/
var rp = require('request-promise');

var optionsStart = {
  method: 'POST',
  uri: 'http://localhost:3000/api/poller',
  body: bodyStart,
  json: true 
};

rp(optionsStart)
  .then(function (parsedBody) {
      console.log(parsedBody);
  })
  .catch(function (err) {
    console.log(err);
  });

  const bodyCancel = {
    action: "cancel"
  }

var optionsCancel = {
  method: 'POST',
  uri: 'http://localhost:3000/api/poller',
  body: bodyCancel,
  json: true 
};

/*
setTimeout(()=>{
  rp(optionsCancel)
  .then(function (parsedBody) {
      console.log(parsedBody);
  })
  .catch(function (err) {
    console.log(err);
  });
},2000)
*/