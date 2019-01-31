import * as types from '../constants/actionTypes';
import restHelper from '../helper/restHelper';

export function loadTemplatesSuccess(templates){
    return { type: types.LOAD_TEMPLATES_SUCCESS, templates:templates};
  }
 

export function loadTemplates(){
    return function(dispatch) {
      return restHelper.get("template")
        .then( (templates) => { dispatch(loadTemplatesSuccess(templates)); } )
        .catch(error => { throw(error); });
    };
  }
