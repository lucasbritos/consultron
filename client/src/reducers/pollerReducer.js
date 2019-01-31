import { WEBSOCKET_CLOSED,WEBSOCKET_OPEN,WEBSOCKET_MESSAGE } from '@giantmachines/redux-websocket'
//import objectAssign from 'object-assign';
import initialState from './initialState';

let clone = (state)=> {
  let newState = {connected:state.connected,busy:state.busy,progress:state.progress}
  newState.errorLog = state.errorLog.map((e) => {return {...e}})
  return newState
}

export default function pollerReducer(state = initialState.poller, action) {
  let newState;
  switch (action.type) {
    case WEBSOCKET_OPEN:
      newState = clone(state)
      newState.connected=true     
      return newState

    case WEBSOCKET_MESSAGE:
      newState = clone(state)
      let data = JSON.parse(action.payload.data)
      switch (data.type) {
        case "busy":
          newState.busy=data.msg
          // reseteo progreso
          if (data.msg==true) {
            newState.progress=0
            newState.errorLog=[]
          }
          return newState;
        case "errorLog":
          newState.errorLog.push(data.msg)
          return newState;
        case "progress":
          newState.progress=data.msg.percentage
          return newState;
        default:
          return state
        }

    case WEBSOCKET_CLOSED:
      newState = clone(state)
      newState.connected=false     
      return newState

    default:
      return state;

  }
}
