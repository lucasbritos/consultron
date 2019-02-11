import { combineReducers } from 'redux';
import project from './projectReducer';
import apps from './appsReducer';
import poller from './pollerReducer';
import host from './hostReducer';
import template from './templateReducer';

const rootReducer = combineReducers({
  project,
  apps,
  poller,
  host,
  template
});

export default rootReducer;
