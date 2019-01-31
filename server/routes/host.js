const Router = require('express-promise-router')

const db = require('../db')

// create a new express-promise-router
// this has the same API as the normal express router except
// it allows you to use async functions as route handlers
const router = new Router()

// export our router to be mounted by the parent application
module.exports = {router}


router.get('/', async (req, res) => {
  const { project } = req.query
  const { rows } = await db.query('SELECT * FROM host JOIN template USING (template_id) WHERE project_id = $1 ',[project] )
  res.send(rows)
})

router.get('/:id', async (req, res) => {
  const { project } = req.query
  const { id } = req.params
  const { rows } = await db.query('SELECT * FROM host WHERE host_id =$1 AND project_id =$2', [id, project])
  res.send(rows[0])
})