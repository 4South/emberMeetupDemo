require('store/Adapter.js');

App.Store = DS.Store.extend({
  revision: 11,
  adapter: DS.SocketAdapter.create()
});
