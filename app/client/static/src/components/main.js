'use strict';

var GoatpadApp = require('./GoatpadApp');
var React = require('react');
var Router = require('react-router');
var Route = Router.Route;

var content = document.getElementById('content');

var Routes = (
  <Route handler={GoatpadApp}>
    <Route name="/" handler={GoatpadApp}/>
  </Route>
);

Router.run(Routes, function (Handler) {
  React.render(<Handler/>, content);
});
