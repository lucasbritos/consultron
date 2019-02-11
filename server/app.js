// ./app.js

require('dotenv').config({ path: '../.env' })
require('dotenv').load();

var bodyParser  = require("body-parser")
const express = require('express')
const cors = require('cors')
const mountRoutes = require('./routes')



const app = express()
var expressWs = require('express-ws')(app);


if (process.env.NODE_ENV == 'production'){
    app.use('/',express.static(__dirname + '/dist'));
}


app.use(cors())
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use('/static', express.static('static'))

mountRoutes(app)

// ... more express setup stuff can follow

app.listen(process.env.SERVER_APP_PORT, function() {
});

console.log(process.env.SERVER_APP_PORT)