let snmp = require('./snmp');
let netSnmp = require ("net-snmp");


let f1 = async () => {
    let v = await snmp.getTableColSnmp("192.168.240.2","R2","1.3.6.1.2.1.2.2",[1,2,4,5,7,8]);
    console.log(v)
}

f1()
const options = {
    port: 1024,
    retries: 3,
    timeout: 2000,
    transport: "udp4",
    trapPort: 162,
    version: netSnmp.Version2
};

let getSnmpOid = async function(ip,community ,oid) {
    return new Promise(function(resolve,reject) {
      var session = netSnmp.createSession(ip, community,options);
      session.get([oid], function (error, res) {
        if (error) { reject(error); return; }
        if (Object.entries(res).length === 0 && res.constructor === Object) { reject(new Error("Empty OID response")); return; }
        resolve(res);
  
      });
    });
  }



let f2 = async () => {
    let v = await getSnmpOid("192.168.240.2","R2","1.3.6.1.2.1.1.5.0");
    console.log(v)
}

f2()

