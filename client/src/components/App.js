/* eslint-disable import/no-named-as-default */
import { Route, Switch } from "react-router-dom";

import AboutPage from "./AboutPage";
//import FuelSavingsPage from "./containers/FuelSavingsPage";
import Header from "./common/Header";
import HomePage from "./HomePage";
import AppsPage from "./containers/AppsPage";
import PollerPage from "./containers/PollerPage";
import NotFoundPage from "./NotFoundPage";
import PropTypes from "prop-types";
import React from "react";
import { hot } from "react-hot-loader";

// This is a class-based component because the current
// version of hot reloading won't hot reload a stateless
// component at the top-level.

class App extends React.Component {
  render() {
    return (
      <div>
        <Header />
        <br/>
        <Switch>
          <Route exact path="/" component={HomePage} />
          <Route path="/apps" component={AppsPage} />
          <Route path="/about" component={AboutPage} />
          <Route path="/poller" component={PollerPage} />
          <Route component={NotFoundPage} />
        </Switch>
      </div>
    );
  }
}

App.propTypes = {
  children: PropTypes.element
};

export default hot(module)(App);
