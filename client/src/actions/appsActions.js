import * as types from '../constants/actionTypes';
import restHelper from '../helper/restHelper';

export function loadAppsSuccess(apps){
    return { type: types.LOAD_APPS_SUCCESS, apps:apps};
  }
 

export function loadApps(){
    return function(dispatch) {
      return restHelper.get("apps")
        .then( (apps) => { dispatch(loadAppsSuccess(apps)); } )
        .catch(error => { throw(error); });
    };
  }
