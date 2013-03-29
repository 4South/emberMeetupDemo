window.App = Ember.Application.create();

require('models/Box.js');

require('store/Adapter.js');

require('store/Store.js');

require('store/Router.js');

require('controllers/BoxsController.js');

require('views/BoxView.js');
