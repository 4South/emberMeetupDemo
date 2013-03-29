#router
App.Router.map () -> @resource "boxs"

#routes   
App.IndexRoute = Em.Route.extend
  redirect: -> @replaceWith('boxs')

App.BoxsRoute = Em.Route.extend
  model: -> App.Box.find()
  setupController: (controller, model)->
    controller.set('content', model)