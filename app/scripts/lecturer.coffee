app = require './app'
ko = require 'knockout'

app.router.pages [
  {
    path: 'students'
    component: require('./pages/students/students')()
  }
  {
    path: 'exercises'
    component: require('./pages/exercises/exercises')()
  }
  {
    path: 'tutors'
    component: require('./pages/tutors/tutors')()
  }
  {
    path: 'groups'
    component: require('./pages/groups/groups')()
  }
  {
    path: 'database'
    component: require('./pages/database/database')()
  }
]
app.load()

$(window).bind "popstate", ->
  app.router.goto location.hash.substr(1)

$(document).ready ->
  $('.ui.dropdown').dropdown()
  $('.ui.accordion').accordion()
  ko.applyBindings app
