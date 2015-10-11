
host = window.location.host;
proto = window.location.protocol;
address = proto + '//'+host+'/api'

ajax = (method, url, data) ->
  $.ajax
    url: address + url
    data: data
    method: method

get = ajax.bind undefined, 'GET'
put = ajax.bind undefined, 'PUT'
post = ajax.bind undefined, 'POST'
del = ajax.bind undefined, 'DELETE'

api =
  get:
    exercises: -> get('/exercises')
    exercise: (id) -> get("/exercises/#{id}")
  put:
    exercise: (exercise) -> put "/exercises", {exercise: exercise}
  post:
    init: -> post '/db/init'
    empty: -> post '/db/empty'

module.exports = api
