import { WEBSOCKET_CONNECT,WEBSOCKET_DISCONNECT } from '@giantmachines/redux-websocket'
import restHelper from '../helper/restHelper';


const websocketUrl = 'ws://'+ window.location.hostname + ':' + process.env.SERVER_APP_PORT +'/api/poller/'

export function connect(){
    return function(dispatch) {
      return dispatch({ type: WEBSOCKET_CONNECT,payload: { url: websocketUrl} })
    };
  }

export function disconnect(){
   return function(dispatch) {
     return dispatch({ type: WEBSOCKET_DISCONNECT })
   };
}

export function sendStartCancel(body){
  return function() {
    return restHelper.post("poller",body)
  };
}

