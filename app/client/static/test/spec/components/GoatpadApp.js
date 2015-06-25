'use strict';

describe('GoatpadApp', function () {
  var React = require('react/addons');
  var GoatpadApp, component;

  beforeEach(function () {
    var container = document.createElement('div');
    container.id = 'content';
    document.body.appendChild(container);

    GoatpadApp = require('components/GoatpadApp.js');
    component = React.createElement(GoatpadApp);
  });

  it('should create a new instance of GoatpadApp', function () {
    expect(component).toBeDefined();
  });
});
