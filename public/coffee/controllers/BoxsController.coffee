App.BoxsController = Em.ArrayController.extend
  addBox: ->
    newBox = App.Box.createRecord
      text: 'New Box'
    newBox.save()
