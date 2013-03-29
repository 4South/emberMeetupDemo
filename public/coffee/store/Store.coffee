require('store/Adapter.js')

# Create ember-data datastore and define our adapter
App.Store = DS.Store.extend
  revision: 11
  adapter: DS.SocketAdapter.create()