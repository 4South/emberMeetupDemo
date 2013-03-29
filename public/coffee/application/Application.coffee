#Starting the App
window.App = Ember.Application.create()

#Loading Dependencies with Minispade
require('models/Box.js')

require('store/Adapter.js')
require('store/Store.js')
require('store/Router.js')

require('controllers/BoxsController.js')
require('views/BoxView.js')

