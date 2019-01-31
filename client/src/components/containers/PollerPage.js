import React from 'react';
import PropTypes from 'prop-types';
import Button from '@material-ui/core/Button';
import {connect} from 'react-redux';
import {bindActionCreators} from 'redux';
import * as pollerActions from '../../actions/pollerActions';
import * as hostActions from '../../actions/hostActions';
import green from '@material-ui/core/colors/green';
import red from '@material-ui/core/colors/red';
import yellow from '@material-ui/core/colors/yellow';
import FormControlLabel from '@material-ui/core/FormControlLabel';
import Checkbox from '@material-ui/core/Checkbox';
import Grid from '@material-ui/core/Grid';
import PollerHostTable from '../PollerHostTable';
import objectAssign from 'object-assign';
import LinearProgress from '@material-ui/core/LinearProgress';
import Paper from '@material-ui/core/Paper';
import Typography from '@material-ui/core/Typography';
import Snackbar from '@material-ui/core/Snackbar';
import IconButton from '@material-ui/core/IconButton';
import CloseIcon from '@material-ui/icons/Close';
import SnackbarContent from '@material-ui/core/SnackbarContent';

const auxStyle = (busy,connected) => {
  const buttonRed = {margin:4,backgroundColor:red[500]}
  const buttonGreen = {margin:4,backgroundColor:green[500]}
  const buttonYellow = {margin:4,backgroundColor:yellow[500]}

  if (!connected) return buttonRed;
  return busy? buttonYellow:buttonGreen
}

const auxLabel = (busy,connected) => {
  if (!connected) return "start";
  return busy? "cancel":"start"
}

const styles = {
  root: {
    flexGrow: 1,
  },
  select:{
    width: 150
  }
};
export class PollerPage extends React.Component {
  constructor(props,context) {
    super(props,context);
    // genero array de booleanos para represantar a cada host
    this.state = { snackBarOpen: false,snackBarMsg: "",debug:false,clean: true, cache: false, host:this.props.host.map((h)=> { return {include:true, ...h}})};

    this.toggleHost = this.toggleHost.bind(this);
    this.toggleOption = this.toggleOption.bind(this);
    this.sendStartCancel = this.sendStartCancel.bind(this);
    this.openSnackBar = this.openSnackBar.bind(this);
    this.closeSnackBar = this.closeSnackBar.bind(this);
  }

  toggleOption(event,checked) {
    let newState = objectAssign({}, this.state)
    newState[event.target.id] = checked
    this.setState(newState)
  }


  toggleHost(event,checked) {
    let newState = objectAssign({}, this.state)
    newState.host[event.target.id].include = checked
    this.setState(newState)
  }

  sendStartCancel(){
    let action = this.props.poller.busy? "cancel":"start" 
    let body = {
      action:action,
      project:this.props.project.selected,
      options:{clean:this.state.clean, cache: this.state.cache, debug:this.state.debug},
      hosts: this.state.host.filter(h => (h.include==true))
    }
    for (let h of body.hosts) {
      h.template_oid = this.props.template.find((t)=> { return t.template_id == h.template_id}).template_oid
    }
    this.props.actions.poller.sendStartCancel(body).then(
      (r)=>{this.openSnackBar('Server: Action ' +r+' received.' )}).catch((err)=> {this.openSnackBar('Server: Error ' + err.message )})
  }

  componentDidMount() {
    this.props.actions.poller.connect()

  }


  openSnackBar(msg) {
    let newState = objectAssign({}, this.state)
    newState.snackBarOpen = true
    newState.snackBarMsg = msg
    this.setState(newState)
  }

  closeSnackBar() {
    let newState = objectAssign({}, this.state)
    newState.snackBarOpen = false
    this.setState(newState)
  }

  componentWillUnmount() {
    this.props.actions.poller.disconnect()
    this.setState({})
  }
  
  render() {
    return (
      <div >
        <Grid container direction="row" justify="space-between" alignItems="flex-start" >
          <Grid item >
            <Button color="primary" variant="contained"
              id = "pepe" 
              onClick={this.sendStartCancel}
              style={auxStyle(this.props.poller.busy,this.props.poller.connected)} 
              disabled={this.props.poller.connected?false:true}> {auxLabel(this.props.poller.busy,this.props.poller.connected) }
            </Button>
          </Grid>
          <Grid item >
          <FormControlLabel
              control={ <Checkbox disabled= {this.props.poller.busy} id="debug" checked={this.state.debug} onChange={this.toggleOption} color="primary" /> }
              label="Debug"
            />
            <FormControlLabel
              control={ <Checkbox disabled= {this.props.poller.busy} id="clean" checked={this.state.clean} onChange={this.toggleOption} color="primary" /> }
              label="Clean DB"
            />
            <FormControlLabel
              control={ <Checkbox disabled= {this.props.poller.busy} id="cache" disabled checked={this.state.cache} onChange={this.toggleOption} value="checkedB" color="primary" /> }
              label="Cache"
            />
          </Grid>
      </Grid>
      <LinearProgress variant="determinate" value={this.props.poller.progress} />
      < PollerHostTable busy={this.props.poller.busy || false} hosts={this.state.host} onChange={this.toggleHost}/>
      <Typography variant="h5" component="h3">
          Server Logs
        </Typography>
      <Paper style={{maxHeight: 200,minHeight:200, overflow: 'auto'}} elevation={1}>
      {this.props.poller.errorLog.map((l,i) => (
        <Typography key={i}component="p">
          {Object.values(l).join("|")}
        </Typography>
      ))}
      </Paper>
      <Snackbar
          anchorOrigin={{
            vertical: 'bottom',
            horizontal: 'left',
          }}
          open={this.state.snackBarOpen}
          autoHideDuration={6000}
          onClose={this.closeSnackBar}
          ContentProps={{
            'aria-describedby': 'message-id',
          }}
          message={<span id="message-id">{this.state.snackBarMsg}</span>}
          action={[
            <IconButton
              key="close"
              aria-label="Close"
              color="inherit"
              onClick={this.closeSnackBar}
            >
              <CloseIcon />
            </IconButton>,
          ]}
        />
      </div>
    );
  }
}

PollerPage.propTypes = {
  project: PropTypes.object.isRequired,
  actions: PropTypes.object.isRequired,
  poller: PropTypes.object.isRequired,
  host: PropTypes.array.isRequired,
  template: PropTypes.array.isRequired
};

function mapStateToProps(state) {
  return {
    project: state.project,
    poller: state.poller,
    host: state.host,
    template: state.template
  };
}

function mapDispatchToProps(dispatch) {
  return {
    actions: {
      poller: bindActionCreators(pollerActions, dispatch),  
      host: bindActionCreators(hostActions, dispatch),  
    }
    
  };
}


export default connect(mapStateToProps,mapDispatchToProps)(PollerPage);
