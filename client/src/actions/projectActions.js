import * as types from '../constants/actionTypes';
import restHelper from '../helper/restHelper';
import * as hostActions from './hostActions'



export function loadProjectsSuccess(projects){
    return { type: types.LOAD_PROJECTS_SUCCESS, projects:projects};
  }
 

export function loadProjects(){
    return function(dispatch) {
      return restHelper.get("project")
        .then( (projects) => {
          dispatch(loadProjectsSuccess(projects)); 
          dispatch(hostActions.loadHosts(projects[0].project_id));
          return null;
        } )
        .catch(error => { throw(error); });
    };
  }



