import * as types from '../constants/actionTypes';
import restHelper from '../helper/restHelper';

export function loadHostsSuccess(hosts){
    return { type: types.LOAD_HOSTS_SUCCESS, hosts:hosts};
  }
 

export function loadHosts(project){
    return function(dispatch) {
      return restHelper.get("host",{project:project})
        .then( (hosts) => { dispatch(loadHostsSuccess(hosts)); } )
        .catch(error => { throw(error); });
    };
  }
