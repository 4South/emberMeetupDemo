# Convenience method for handling saves of state via the model.
DS.Model.reopen 
  save: ->
    App.store.commit()

App.Box = DS.Model.extend
  text:   DS.attr 'string'

