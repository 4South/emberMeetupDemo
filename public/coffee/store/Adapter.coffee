#Declaring variables for convenience
TYPES =
  CREATE: "CREATE"
  CREATES: "CREATES"
  UPDATE: "UPDATE"
  UPDATES: "UPDATES"
  DELETE: "DELETE"
  DELETES: "DELETES"
  FIND: "FIND"
  FIND_MANY: "FIND_MANY"
  FIND_QUERY: "FIND_QUERY"
  FIND_ALL: "FIND_ALL"

#Adapter Definition begins  
DS.SocketAdapter = DS.RESTAdapter.extend
  socket: undefined
  requests: undefined
  #Create a unique ID to store client-side callbacks to be run when server responds
  generateUuid: ->
    S4 = ->
      Math.floor(Math.random() * 0x10000).toString 16
    S4() + S4() 

  #Format the data packet to be sent to the back-end  
  send: (request) ->
    request.uuid = @generateUuid()
    request.context = this
    @get("requests")[request.uuid] = request       
 
    data =
      uuid: request.uuid
      action: request.requestType
      type: @rootForType(request.type)
      model: request.type.toString()
      
    if request.record isnt undefined
      data.record = @serialize(request.record,
        includeId: true
      )
    if request.id isnt undefined
      data.id = request.id  

    @socket.emit "ember-data", data

  #Adapter operations defined
  find: (store, type, id) ->
    @send
      store: store
      type: type
      id: id
      requestType: TYPES.FIND
      callback: (req, res) ->
        Ember.run req.context, ->
          @didFindRecord req.store, req.type, res, req.id

  findAll: (store, type, since) ->
    @send
      store: store
      type: type
      since: @sinceQuery(since)
      requestType: TYPES.FIND_ALL
      callback: (req, res) ->
        Ember.run req.context, ->
          @didFindAll req.store, req.type, res

  createRecord: (store, type, record) ->
    @send
      store: store
      type: type
      record: record
      requestType: TYPES.CREATE
      callback: (req, res) ->
        Ember.run req.context, ->
          @didCreateRecord req.store, req.type, req.record, res

  updateRecord: (store, type, record) ->
    @send
      store: store
      type: type
      record: record
      requestType: TYPES.UPDATE
      callback: (req, res) ->
        Ember.run req.context, ->
          @didSaveRecord req.store, req.type, req.record, res

  deleteRecord: (store, type, record) ->
    @send
      store: store
      type: type
      record: record
      requestType: TYPES.DELETE
      callback: (req, res) ->
        Ember.run req.context, ->
          @didSaveRecord req.store, req.type, req.record

  #In the init method we define the socket connection and events
  init: ->
    @_super()
    context = this
    @set "requests", {}
    #ws is the connection to the websocket
    ws = io.connect("//" + "localhost")
    #events start here. "ember-data" is the response from server for own requests
    ws.on "ember-data", (payload) ->
      uuid = payload.uuid
      request = context.get("requests")[uuid]
      if payload.data
        request.callback request, payload.data
    #these events are received on non-originating clients to keep them in sync
    #TODO: find way to not hardcode the model here in App.store.find
    ws.on "delete", (payload) ->
      boxId = payload.data['box'].id
      box = App.store.find(App.Box, boxId)
      App.store.unloadRecord(box)
    
    ws.on "create", (payload) ->
      App.store.load(App.Box, payload.data[payload.type])
    
    ws.on "update", (payload) ->
      App.store.load(App.Box, payload.data[payload.type])

    @set "socket", ws

DS.SocketAdapter.map 'App.Box',
  box: { key: 'boxs' }
  
