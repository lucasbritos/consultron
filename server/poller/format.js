const utf8 = require('utf8');

const formats = {
    ipAddress: (input) => {return input[0]+"."+input[1]+"."+ input[2]+"."+ input[3];},
    macAddress: (input) => { return input.toString('hex'); },
    test: (input) => { return "test"; },
    defaultInt: (input)=> (input || 0),
    defaultStr: (input)=> (input || ""),
    encodeUtf8: (input)=> utf8.encode(input)
  }

var removeCrLr = function (string){ return string.replace(/\r?\n|\r/g," ").replace(/,/g,";"); }

// Converts object notation to array and apply format 
let applyFormatTable = function(obj,template_oid){
  var array = [];
  for (let index in obj) {
    let newRow = [index];
    for (i = 0; i < template_oid.cols.length; i++) {
      let value;
      if (template_oid.format.hasOwnProperty(i)) {
        value = eval(template_oid.format[i])(obj[index][template_oid.cols[i]])
      } else {
        if (Buffer.isBuffer(obj[index][template_oid.cols[i]])) { 
          value = obj[index][template_oid.cols[i]].toString(); 
        } else {
          value = obj[index][template_oid.cols[i]]      
        }
        if (typeof value == "string") value = removeCrLr(value);
      }
      newRow.push(value)
    }
    array.push(newRow);
  }
  return array;
}

let applyFormatSingle = function(value,template_oid){
  if (Buffer.isBuffer(value)) value = value.toString();
  value = removeCrLr(value);
  return [[value]];
}



module.exports = {
  applyFormatTable,
  applyFormatSingle
}
