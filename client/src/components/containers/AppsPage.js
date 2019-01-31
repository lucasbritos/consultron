import React from 'react';
import PropTypes from 'prop-types';
import { withStyles } from '@material-ui/core/styles';
import GridList from '@material-ui/core/GridList';
import GridListTile from '@material-ui/core/GridListTile';
import GridListTileBar from '@material-ui/core/GridListTileBar';
import IconButton from '@material-ui/core/IconButton';
import OpenInNewIcon from '@material-ui/icons/OpenInNew';
import GetAppIcon from '@material-ui/icons/GetApp';
import {connect} from 'react-redux';


const styles = theme => ({
  root: {
    display: 'flex',
    flexWrap: 'wrap',
    justifyContent: 'space-around',
    overflow: 'hidden',
    backgroundColor: theme.palette.background.paper,
  },
  gridList: {
    width: 900,
    height: 600,
  },
  icon: {
    color: 'rgba(255, 255, 255, 0.54)',
  },
});
 
function AppsPage(props) {

  const { classes, apps, project } = props;
  const img = 'http://'+ window.location.hostname+':' + process.env.SERVER_APP_PORT +'/static/apps/1/app.png'

  return (
    <div className={classes.root}>
      <GridList cellHeight={180} className={classes.gridList}>
        {apps.map(a => (
          <GridListTile key={a.apps_id}>
            <img src={'http://'+ window.location.hostname+':' + process.env.SERVER_APP_PORT +'/static/apps/'+ a.apps_id +'/app.png'} />
            <GridListTileBar
              title={a.apps_name}
              actionIcon={[
                <IconButton key ={a.apps_id} className={classes.icon}
                  onClick={() => { window.open('http://'+ window.location.hostname +':' + process.env.SERVER_APP_PORT + '/api/apps/'+a.apps_id+'/?format=csv&project='+project.selected); }}
                >
                  <GetAppIcon />
                </IconButton>,
                <IconButton key ={a.apps_id+1000} className={classes.icon}
                  onClick={() => { window.open('http://'+ window.location.hostname +':' + process.env.SERVER_APP_PORT + '/static/apps/'+a.apps_id+'/?project='+project.selected,'visor','height=750,width=1200'); }}
                >
                  <OpenInNewIcon />
                </IconButton>
              ]}
            />
          </GridListTile>
        ))}
      </GridList>
    </div>
  );
}

AppsPage.propTypes = {
  classes: PropTypes.object.isRequired,
  apps: PropTypes.array.isRequired,
  project: PropTypes.object.isRequired
};

function mapStateToProps(state) {
  return {
    apps: state.apps,
    project: state.project
  };
}

function mapDispatchToProps() {
  return {};
}


export default connect(mapStateToProps,mapDispatchToProps)(withStyles(styles)(AppsPage));