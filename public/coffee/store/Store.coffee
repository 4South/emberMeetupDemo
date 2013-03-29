#imports the adapter
require('store/Adapter.js')

# Create ember-data datastore and define our adapter
App.store = DS.Store.create
  revision: 11
  adapter: DS.SocketAdapter.create()

# Convenience method for handling saves of state via the model.
DS.Model.reopen 
  save: ->
    App.store.commit()
