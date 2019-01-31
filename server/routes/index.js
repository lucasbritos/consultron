// ./routes/index.js
const project = require('./project')
const host = require('./host')
const template = require('./template')
const oid = require('./oid')
const poller = require('./poller')
const apps = require('./apps')

module.exports = (app) => {
  app.use('/api/project', project.router)
  app.use('/api/host', host.router)
  app.use('/api/template', template.router)
  app.use('/api/oid', oid.router)
  app.use('/api/poller', poller.router)
  app.use('/api/apps', apps.router)
  // etc..
}