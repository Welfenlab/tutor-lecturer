
var bcrypt = require('bcrypt-then');
var _ = require('lodash');

module.exports = function(DB){
  return [
    { path: '/api/exercises', dataCall: DB.Exercises.get, apiMethod: "get" },
    { path: '/api/exercises/:id', dataCall: DB.Exercises.getById, apiMethod: "getByParam", param: "id" },
    { path: '/api/exercises', dataCall: DB.Manage.storeExercise, apiMethod: "putByBodyParam", param: "exercise" },

    { path: '/api/tutors', dataCall: DB.Manage.listTutors, apiMethod: "get"},
    { path: '/api/tutors', dataCall: function(tutor){
      // first generate some salt and create a password hash ;)
      // the salt is stored in the hash
      return bcrypt.hash(tutor.pw, 10).then(
        _.partial(DB.Manage.storeTutor, tutor.name)
      );
    }, apiMethod: "putByBodyParam", param: "tutor"},

    { path: '/api/groups', dataCall: DB.Manage.listGroups, apiMethod: "get" },

    { path: '/api/users', dataCall: DB.Manage.listUsers, apiMethod: "get"},

  ];
};
