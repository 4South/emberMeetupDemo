var TYPES;

TYPES = {
  CREATE: "CREATE",
  CREATES: "CREATES",
  UPDATE: "UPDATE",
  UPDATES: "UPDATES",
  DELETE: "DELETE",
  DELETES: "DELETES",
  FIND: "FIND",
  FIND_MANY: "FIND_MANY",
  FIND_QUERY: "FIND_QUERY",
  FIND_ALL: "FIND_ALL"
};

DS.SocketAdapter = DS.RESTAdapter.extend({
  socket: void 0,
  requests: void 0,
  generateUuid: function() {
    var S4;

    S4 = function() {
      return Math.floor(Math.random() * 0x10000).toString(16);
    };
    return S4() + S4();
  },
  send: function(request) {
    var data;

    request.uuid = this.generateUuid();
    request.context = this;
    this.get("requests")[request.uuid] = request;
    data = {
      uuid: request.uuid,
      action: request.requestType,
      type: this.rootForType(request.type),
      model: request.type.toString()
    };
    if (request.record !== void 0) {
      data.record = this.serialize(request.record, {
        includeId: true
      });
    }
    if (request.id !== void 0) {
      data.id = request.id;
    }
    return this.socket.emit("ember-data", data);
  },
  find: function(store, type, id) {
    return this.send({
      store: store,
      type: type,
      id: id,
      requestType: TYPES.FIND,
      callback: function(req, res) {
        return Ember.run(req.context, function() {
          return this.didFindRecord(req.store, req.type, res, req.id);
        });
      }
    });
  },
  findAll: function(store, type, since) {
    return this.send({
      store: store,
      type: type,
      since: this.sinceQuery(since),
      requestType: TYPES.FIND_ALL,
      callback: function(req, res) {
        return Ember.run(req.context, function() {
          return this.didFindAll(req.store, req.type, res);
        });
      }
    });
  },
  createRecord: function(store, type, record) {
    return this.send({
      store: store,
      type: type,
      record: record,
      requestType: TYPES.CREATE,
      callback: function(req, res) {
        return Ember.run(req.context, function() {
          return this.didCreateRecord(req.store, req.type, req.record, res);
        });
      }
    });
  },
  updateRecord: function(store, type, record) {
    return this.send({
      store: store,
      type: type,
      record: record,
      requestType: TYPES.UPDATE,
      callback: function(req, res) {
        return Ember.run(req.context, function() {
          return this.didSaveRecord(req.store, req.type, req.record, res);
        });
      }
    });
  },
  deleteRecord: function(store, type, record) {
    return this.send({
      store: store,
      type: type,
      record: record,
      requestType: TYPES.DELETE,
      callback: function(req, res) {
        return Ember.run(req.context, function() {
          return this.didSaveRecord(req.store, req.type, req.record);
        });
      }
    });
  },
  init: function() {
    var context, ws;

    this._super();
    context = this;
    this.set("requests", {});
    ws = io.connect("//" + "localhost");
    ws.on("ember-data", function(payload) {
      var request, uuid;

      uuid = payload.uuid;
      request = context.get("requests")[uuid];
      if (payload.data) {
        return request.callback(request, payload.data);
      }
    });
    ws.on("delete", function(payload) {
      var box, boxId;

      boxId = payload.data['box'].id;
      box = App.store.find(App.Box, boxId);
      return App.store.unloadRecord(box);
    });
    ws.on("create", function(payload) {
      return App.store.load(App.Box, payload.data[payload.type]);
    });
    ws.on("update", function(payload) {
      return App.store.load(App.Box, payload.data[payload.type]);
    });
    return this.set("socket", ws);
  }
});

DS.SocketAdapter.map('App.Box', {
  box: {
    key: 'boxs'
  }
});
