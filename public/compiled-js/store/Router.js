App.Router.map(function() {
  return this.resource("boxs");
});

App.IndexRoute = Em.Route.extend({
  redirect: function() {
    return this.replaceWith('boxs');
  }
});

App.BoxsRoute = Em.Route.extend({
  model: function() {
    return App.Box.find();
  },
  setupController: function(controller, model) {
    return controller.set('content', model);
  }
});
