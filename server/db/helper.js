

const db = require('./')

let writeDB = async (data,project,options) => {
  // Borro todos los datos del proyecto
  if (options.clean) { await cleanProject(project) }
  

  // Borro los datos de los hosts y de las tablas que estoy por cargar
  for (alias in data){
    for (table in data[alias]){
      // Borro los datos que haya de esta combinacion de table, host(alias) y proyecto
      await cleanTable(table,alias,project);
      // Finalmente agrego los datos
      await insertTable(table,project,data[alias][table])
    }

  }

}

let insertTable = async (table,project,data) => {
  for (row of data) {
    row.unshift(alias)
    row.unshift(project)
    param = ""
    for (i in row) { param += '$'+(parseInt(i)+1)+','}
    param = param.slice(0, -1); // saco la ultima coma
    //console.log(row);
    //console.log('INSERT INTO '+ table +' VALUES('+param+')')
    await db.query('INSERT INTO '+ table +' VALUES('+param+')',row)
  }

};

let cleanTable = async (table,alias,project) => {
  await db.query('DELETE FROM '+ table +' WHERE project_id = $1 AND alias = $2', [project,alias])
}

let cleanProject = async (project) => {
  const { rows:tables } = await db.query('SELECT table_name FROM tables_schema')
  for (t of tables){
    await db.query('DELETE FROM '+t.table_name+' WHERE project_id = $1', [project])
  }
}


module.exports = { 
  writeDB
 };
