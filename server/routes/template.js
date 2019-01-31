const Router = require('express-promise-router')

const db = require('../db')

// create a new express-promise-router
// this has the same API as the normal express router except
// it allows you to use async functions as route handlers
const router = new Router()

// export our router to be mounted by the parent application
module.exports = {router}


router.get('/', async (req, res) => {
  const { rows } = await db.query('SELECT * FROM template')
  for (t of rows) {
    const { rows: template_oid } = await db.query('SELECT table_name,oid,mib,cols,format,type,oid_id FROM template_oid JOIN oid USING (oid_id) JOIN tables_schema USING (table_id) WHERE template_id = $1', [t.template_id])  
    t.template_oid = template_oid
  }
  res.send(rows)
})

router.get('/:id', async (req, res) => {
  const { id } = req.params
  const { rows } = await db.query('SELECT * FROM template WHERE template_id = $1', [id])
  const { rows: template_oid } = await db.query('SELECT table_name,oid,mib,cols,format,type,oid_id FROM template_oid JOIN oid USING (oid_id) JOIN tables_schema USING (table_id) WHERE template_id = $1', [id])
  rows[0].template_oid = template_oid
  res.send(rows[0])
})