const Router = require('express-promise-router')

const router = new Router()
let poller = require('../poller')

module.exports = {router}
var expressWs = require('express-ws')(router);


router.post('/', async (req, res) => {
  poller.handlePost(req,res)
})

router.ws('/', async (ws, req) => {
  poller.handleWS(ws)
});


