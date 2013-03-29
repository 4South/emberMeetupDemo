App.BoxView = Em.CollectionView.extend({
  contentBinding: 'controller.content',
  itemViewClass: Em.View.extend({
    isEditing: false,
    isHovered: false,
    templateName: 'box',
    classNames: ['box'],
    mouseEnter: function() {
      return this.set('isHovered', true);
    },
    mouseLeave: function() {
      return this.set('isHovered', false);
    },
    doubleClick: function() {
      return this.set('isEditing', true);
    },
    editingView: Em.TextArea.extend({
      classNames: ['editfield'],
      valueBinding: 'parentView.content.text',
      didInsertElement: function() {
        return this.$().focus();
      },
      editFinished: function() {
        this.get('parentView.content').save();
        return this.get('parentView').set('isEditing', false);
      },
      focusOut: function() {
        return this.editFinished();
      },
      keyUp: function(event) {
        if (event.keyCode === 27 || event.keyCode === 13) {
          return this.editFinished();
        }
      }
    }),
    deleteBox: Em.View.extend({
      classNames: ['deleteBox'],
      click: function() {
        this.get('parentView.content').deleteRecord();
        return this.get('parentView.content').save();
      }
    })
  })
});
