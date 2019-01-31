import { combineReducers } from 'redux';
import fuelSavings from './fuelSavingsReducer';
import project from './projectReducer';
import apps from './appsReducer';
import poller from './pollerReducer';
import host from './hostReducer';
import template from './templateReducer';

const rootReducer = combineReducers({
  fuelSavings,
  project,
  apps,
  poller,
  host,
  template
});

export default rootReducer;
