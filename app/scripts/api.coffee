Q = require 'q'
host = window.location.host;
proto = window.location.protocol;
address = proto + '//'+host+'/api'

ajax = (method, url, data) ->
  Q $.ajax
    url: address + url
    data: JSON.stringify data
    contentType: 'application/json; charset=utf-8'
    dataType: 'json'
    method: method

get = ajax.bind undefined, 'GET'
put = ajax.bind undefined, 'PUT'
post = ajax.bind undefined, 'POST'
del = ajax.bind undefined, 'DELETE'

api =
  tutors:
    getAll: -> get '/tutors'
    create: (tutor) -> post '/tutors', {tutor: tutor}

  students:
    getAll: -> get '/students'

  groups:
    getAll: -> get '/groups'

  solutions:
    getOfStudent: (id) -> get "/students/#{id}/solutions"
    search: (query) -> get '/solutions', {search: query}

  get:
    exercises: -> get('/exercises')
    exercise: (id) -> get("/exercises/#{id}")

  put:
    exercise: (exercise) -> put "/exercises", {exercise: exercise}

  database:
    initialize: -> post '/db/init'
    clear: -> post '/db/empty'

module.exports = api
