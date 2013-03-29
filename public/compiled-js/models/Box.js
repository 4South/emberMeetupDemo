DS.Model.reopen({
  save: function() {
    return App.store.commit();
  }
});

App.Box = DS.Model.extend({
  text: DS.attr('string')
});
