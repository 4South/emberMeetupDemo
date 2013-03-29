#Here we are using a Collection View since there are going to be child views that are conditionally visible
App.BoxView = Em.CollectionView.extend
  contentBinding: 'controller.content'
  #itemViewClass is defining the parent view for each item in the collection
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
    #first conditional view which will be shown on a doubleclick of the text box
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
    #another conditional view, shown when hovering over a text box
    deleteBox: Em.View.extend
      classNames: ['deleteBox']
      click: ()->
        @get('parentView.content').deleteRecord()
        @get('parentView.content').save()
  
  