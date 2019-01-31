var rp = require('request-promise');

const API = "http://" + window.location.hostname + ":" + process.env.SERVER_APP_PORT + "/api/";

class restHelper {
	static get = (url,qs) => rp({method: 'get', uri: API + url, json: true,qs:qs })
    
    static post = (url,data) => rp({method: 'post', uri: API + url,body: data, json: true })

    static put = (url,data) => rp({method: 'put', uri: API + url,body: data, json: true })

    static delete = (url,data) => rp({method: 'delete', uri: API + url,body: data, json: true })
}

export default restHelper;