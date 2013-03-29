require('store/Adapter.js');

App.store = DS.Store.create({
  revision: 11,
  adapter: DS.SocketAdapter.create()
});

DS.Model.reopen({
  save: function() {
    return App.store.commit();
  }
});
