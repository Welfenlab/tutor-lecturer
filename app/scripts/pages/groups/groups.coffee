ko = require 'knockout'
_ = require 'lodash'
api = require '../../api'
wavatar = require('../../util/gravatar').wavatar

class UserViewModel
  constructor: (user) ->
    @name = user
    @avatarUrl = wavatar @name

class GroupViewModel
  constructor: (group) ->
    @id = group.id
    @shortId = ko.computed => @id.substring(0, 6)
    @members = group.users.map (u) -> new UserViewModel(u)
    @pendingMembers = ko.observableArray group.pendingUsers.map (u) -> new UserViewModel(u)

class ViewModel
  constructor: ->
    @groups = ko.observableArray()

    api.groups.getAll()
    .then (groups) => @groups groups.map (g) -> new GroupViewModel(g)

fs = require 'fs'
module.exports = ->
  ko.components.register __filename.substr(__dirname.length, __filename.length - 7),
    template: fs.readFileSync __filename.substr(0, __filename.length - 7) + '.html', 'utf8'
    viewModel: ViewModel
  return __filename.substr(__dirname.length, __filename.length - 7)
