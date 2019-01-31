const Router = require('express-promise-router')
const Json2csvParser = require('json2csv').Parser;

const db = require('../db')

// create a new express-promise-router
// this has the same API as the normal express router except
// it allows you to use async functions as route handlers
const router = new Router()

// export our router to be mounted by the parent application
module.exports = {router}

router.get('/', async (req, res) => {
  const { rows } = await db.query('SELECT * FROM apps')
  res.send(rows)
})

router.get('/:id', async (req, res) => {
    const { id } = req.params
    const { project, format } = req.query
    const { rows:apps } = await db.query('SELECT * FROM apps WHERE apps_id=$1',[id])
    let a = apps[0]
    const { rows,fields } = await db.query(a.apps_query + ' WHERE host.project_id=$1',[project])
    if (format && format=="csv") { 
      const json2csvParser = new Json2csvParser({ fields:fields.map((f)=>{ return f.name }), eol:"\r\n" });
      res.setHeader('Content-type', "application/octet-stream");
      res.setHeader('Content-disposition', 'attachment; filename='+a.apps_name+".csv");
      res.setHeader('Cache-Control', "no-cache")
      res.send(json2csvParser.parse(rows)); return;
    }
    res.send(rows)
  })
  
