import React from 'react';
import PropTypes from 'prop-types';
import { withStyles } from '@material-ui/core/styles';
import Table from '@material-ui/core/Table';
import TableBody from '@material-ui/core/TableBody';
import TableCell from '@material-ui/core/TableCell';
import TableHead from '@material-ui/core/TableHead';
import TableRow from '@material-ui/core/TableRow';
import Paper from '@material-ui/core/Paper';
import Checkbox from '@material-ui/core/Checkbox';

const styles = theme => ({
  root: {
    width: '100%',
    marginTop: theme.spacing.unit * 3,
    overflowX: 'auto',
  },
  table: {
    minWidth: 700,
  },
});

function PollerHostTable(props) {
  const { classes, hosts, onChange,busy } = props;

  return (
    <Paper className={classes.root}>
      <Table className={classes.table}>
        <TableHead>
          <TableRow>
            <TableCell></TableCell>
            <TableCell align="right">Alias</TableCell>
            <TableCell align="right">IP Address</TableCell>
            <TableCell align="right">Port</TableCell>
            <TableCell align="right">Community</TableCell>
            <TableCell align="right">Location</TableCell>
            <TableCell align="right">Template</TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
        {hosts.map((h,i) => (
          <TableRow key={h.alias}>
            <TableCell component="th" scope="row">
            <Checkbox disabled={busy} id={i.toString()} checked={h.include} onChange={onChange} value="" color="primary" key={i}/>
            </TableCell>
            <TableCell align="right">{h.alias}</TableCell>
            <TableCell align="right">{h.ip_address}</TableCell>
            <TableCell align="right">{h.port}</TableCell>
            <TableCell align="right">{h.community}</TableCell>
            <TableCell align="right">{h.location}</TableCell>
            <TableCell align="right">{h.template_name}</TableCell>
          </TableRow>
         ))}
      </TableBody>
    </Table>
  </Paper>
  );
}


PollerHostTable.propTypes = {
  classes: PropTypes.object.isRequired,
  hosts: PropTypes.array.isRequired,
  onChange: PropTypes.func.isRequired,
  busy: PropTypes.bool.isRequired
};

export default withStyles(styles)(PollerHostTable);