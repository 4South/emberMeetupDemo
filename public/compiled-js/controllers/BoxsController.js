App.BoxsController = Em.ArrayController.extend({
  addBox: function() {
    var newBox;

    newBox = App.Box.createRecord({
      text: 'New Box'
    });
    return newBox.save();
  }
});
