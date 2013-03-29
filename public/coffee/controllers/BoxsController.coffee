App.BoxsController = Em.ArrayController.extend
  #Creates a new Box Record with some default text
  addBox: ->
    newBox = App.Box.createRecord
      text: 'New Box'
    #Calls the .save helper on the model, which calls the commit method on the Store  
    newBox.save()
