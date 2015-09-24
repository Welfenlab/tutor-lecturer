
var bcrypt = require('bcrypt');

module.exports = function(DB){
  return [
    { path: '/api/exercises', dataCall: DB.Exercises.get, apiMethod: "get" },
    { path: '/api/exercises/detailed/:id', dataCall: DB.Exercises.getDetailed, apiMethod: "getByParam", param: "id" },
    { path: '/api/exercises', dataCall: DB.Manage.storeExercise, apiMethod: "putByBodyParam", param: "exercise" },

    { path: '/api/tutors', dataCall: DB.Manage.listTutors, apiMethod: "get"},
    { path: '/api/tutors', dataCall: function(tutor){
      return new Promise(function(resolve, reject){
        // first generate some salt and create a password hash ;)
        // the salt is stored in the hash
        bcrypt.hash(tutor.pw, 10, function(err,hash){
          if(err){
            reject(err)
          } else {
            DB.Manage.storeTutor(tutor.name, hash).then(resolve);
          }
        });
      });
    }, apiMethod: "putByBodyParam", param: "tutor"},

    { path: '/api/groups', dataCall: DB.Manage.listGroups, apiMethod: "get" },

    { path: '/api/users', dataCall: DB.Manage.listUsers, apiMethod: "get"},

  ];
};
