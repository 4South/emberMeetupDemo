App.BoxView = Em.CollectionView.extend
  contentBinding: 'controller.content'
  itemViewClass: Em.View.extend
    isEditing: false
    isHovered: false
    templateName: 'box'
    classNames: ['box']
    mouseEnter: ()->
      @set('isHovered', true)
    mouseLeave: ()->
      @set('isHovered', false)
    doubleClick: ()->
      @set('isEditing', true)
    editingView: Em.TextArea.extend
      classNames: ['editfield']
      valueBinding: 'parentView.content.text'
      didInsertElement: ->
        @$().focus()
      editFinished: ->
        @get('parentView.content').save()
        @get('parentView').set('isEditing', false)
      focusOut: ->
        @editFinished()
      keyUp: (event)->
        if event.keyCode == 27 or event.keyCode == 13
          @editFinished()
    deleteBox: Em.View.extend
      classNames: ['deleteBox']
      click: ()->
        @get('parentView.content').deleteRecord()
        @get('parentView.content').save()
  
  