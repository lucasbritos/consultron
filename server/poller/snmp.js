let netSnmp = require ("net-snmp");
let format =  require("./format");

const options = {
    port: 1024,
    retries: 3,
    timeout: 2000,
    transport: "udp4",
    trapPort: 162,
    version: netSnmp.Version2
};


let getSnmp = async (h,t) => {
  options.port = h.port; // Override default options
  if (t.type == "table") {
    return getTableColSnmp(h,t);
  }
  else if (t.type == "single") {
    return getSnmpOid(h,t);
  } else {
    return Promise.resolve([]);
  }
}


let getTableColSnmp = async function (h,t) {
  return new Promise(function(resolve,reject) {
    var session = netSnmp.createSession (h.ip_address, h.community,options);
    function responseCb (error, res) {
      if (error) { reject(error); return; }
      // Check if object is empty  https://stackoverflow.com/questions/679915/how-do-i-test-for-an-empty-javascript-object
      if (Object.entries(res).length === 0 && res.constructor === Object) { reject(new Error("Empty OID response")); return; }
      let formatted = format.applyFormatTable(res,t) 
      resolve(formatted);
    }
    var maxRepetitions = 20;
    session.tableColumns(t.oid, t.cols, maxRepetitions, responseCb);
  });
}

let getSnmpOid = async function(h,t) {
  return new Promise(function(resolve,reject) {
    var session = netSnmp.createSession(h.ip_address, h.community,options);
    session.get([t.oid], function (error, res) {
      if (error) { reject(error); return; }
      if (Object.entries(res).length === 0 && res.constructor === Object) { reject(new Error("Empty OID response")); return; }
      let formatted = format.applyFormatSingle(res[0].value.toString('utf8'),t)
      resolve(formatted);
    });
  });
}

module.exports = {
  getSnmp
}

