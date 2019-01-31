let snmp = require('./snmp');
let helper =  require("../db/helper");

let busy = false;

let wsRef;

let handleWS = (ws) => {
  wsRef = ws;
  setStatus();

}

let setStatus = (v) => {
  if (v != null) {
    busy = v;
    wsRef.send(JSON.stringify({"type":"busy","msg":busy}));
  } else {
    wsRef.send(JSON.stringify({"type":"busy","msg":busy}));
  }
  
  
}


let cancelFlag = false;

let handlePost = (req,res) => {
  if (req.body.action == "start") { 
    // TODO: Check input format & integrity and throw err
    try {start(req.body.hosts,req.body.project,req.body.options);} 
    catch {console.log(err)}
    } 
  if (req.body.action == "cancel") { 
    cancelFlag = true
  }
  res.status(200).send(req.body.action)
  // TODO: res default
}

let start = async (hosts,project,options) => {

  // Calculo la cantidad de interacciones
  
  setStatus(true);

  let totalIter = 0;
  for (const h of hosts) {
      totalIter += h.template_oid.length;
  }
  
  countIter = 0
  let sendProgress = ()  => {
    countIter++;
    wsRef.send(JSON.stringify({"type":"progress","msg":{"percentage":Math.floor(countIter/totalIter*100)}}));
  }

  let sendErrorLog = (msg,facility)  => {
    wsRef.send(JSON.stringify({"type":"errorLog","msg":msg, "facility":facility}));
    //wsRef.send([h.ip_address,h.community,t.table_name,facility,msg].join(" "));
  }

  // SNMP & FORMAT
  results= {};
  for (const h of hosts) {
    for (const t of h.template_oid) {
      if (options.debug) {sendErrorLog({"host":h.ip_address,"port":h.port ,"community":h.community,"oid":t.oid,table_name:t.table_name,"msg":"DEBUG"})}
      if (cancelFlag) { setStatus(false); cancelFlag = false ; return; }
      // SNMP
      sendProgress()
      let response;
      try { response = await snmp.getSnmp(h,t); }
      catch(err) { sendErrorLog({"host":h.ip_address,"port":h.port ,"community":h.community,"oid":t.oid,table_name:t.table_name,"msg":err.message},"SNMP Poll"); continue; } 

      // PUSH RESULTS
      if (results[h.alias] === undefined) results[h.alias] = {}
      if (results[h.alias][t.table_name] === undefined) results[h.alias][t.table_name] = {}
      results[h.alias][t.table_name]=response;
    }
  }
  
  // Write DB
  try {await helper.writeDB(results,project,options); }
  catch(err) { sendErrorLog({"msg":err.message},"writeDB") }
  
  //console.log(results)
  setStatus(false);
  return;
}
  

async function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

module.exports = {
  handleWS,
  handlePost
}


