import React from 'react';
import Button from '@material-ui/core/Button';
import Menu from '@material-ui/core/Menu';
import MenuItem from '@material-ui/core/MenuItem';
import { NavLink } from "react-router-dom";

const styles = {
  button:{
    margin:4
  }
};


class PollerMenu extends React.Component {
  state = {
    anchorEl: null,
  };

  handleClick = event => {
    this.setState({ anchorEl: event.currentTarget });
  };

  handleClose = () => {
    this.setState({ anchorEl: null });
  };

  render() {
    const { anchorEl } = this.state;

    return (
      <div>
        <Button
          variant="contained"
          aria-owns={anchorEl ? 'simple-menu' : undefined}
          aria-haspopup="true"
          onClick={this.handleClick}
          style={styles.button}
        >
          Settings
        </Button>
        <Menu
          id="simple-menu"
          anchorEl={anchorEl}
          open={Boolean(anchorEl)}
          onClose={this.handleClose}
        >
          <NavLink exact to="/" ><MenuItem onClick={this.handleClose}>Projects</MenuItem></NavLink >
          <NavLink to="/apps" ><MenuItem onClick={this.handleClose}>Hosts</MenuItem></NavLink>
          <MenuItem onClick={this.handleClose}>Templates</MenuItem>
        </Menu>
      </div>
    );
  }
}

export default PollerMenu;