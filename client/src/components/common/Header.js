import React from 'react';
import PropTypes from 'prop-types';
import AppBar from '@material-ui/core/AppBar';
import Toolbar from '@material-ui/core/Toolbar';
import Button from '@material-ui/core/Button';
import NativeSelect from '@material-ui/core/NativeSelect';
import InputLabel from '@material-ui/core/InputLabel';
import {connect} from 'react-redux';
import PollerMenu from "./PollerMenu";

import Grid from '@material-ui/core/Grid';

import { NavLink } from "react-router-dom";

const styles = {
  root: {
    flexGrow: 1,
  },
  select:{
    width: 150
  },
  button:{
    margin:4
  }
};
export class Header extends React.Component {
  render() {
    return (
      <div >
        <AppBar position="static" color="default">
          <Toolbar>
          <Grid container direction="row" justify="space-between" alignItems="flex-start" >
          <Grid item >
            <NavLink exact to="/" ><Button variant="contained" style={styles.button}> Home </Button></NavLink>
            <NavLink to="/apps" ><Button variant="contained" style={styles.button}> Apps </Button></NavLink>
            <NavLink to="/poller" ><Button variant="contained" style={styles.button} > Poller </Button></NavLink>
            <NavLink to="/about" ><Button variant="contained" style={styles.button}> About </Button></NavLink>
            
          </ Grid>
          <Grid item ><PollerMenu /></Grid>
          <Grid item >
            <InputLabel htmlFor="project-select">Project </InputLabel>
            <NativeSelect
              style={styles.select}
              value={this.props.project.selected} 
              onChange={()=>{}}
              inputProps={{
                name: 'age',
                id: 'project-select',
              }}>
              {this.props.project.list.map(p => <option key={p.project_id} value={p.project_id}>{p.project_name}</option>)}
            </NativeSelect>
            </Grid>
            </Grid>
          </Toolbar>
        </AppBar>
      </div>
    );
  }
}

Header.propTypes = {
  project: PropTypes.object.isRequired
};

function mapStateToProps(state) {
  return {
    project: state.project
  };
}

function mapDispatchToProps() {
  return {};
}


export default connect(mapStateToProps,mapDispatchToProps)(Header);
// {this.props.projects.map(p => <option value={p.project_id}>{p.project_name}</option>)}