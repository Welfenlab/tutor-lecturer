
module.exports = function(DB){
  return [
    { path: '/api/exercises', dataCall: DB.Exercises.get, apiMethod: "get" },
    { path: '/api/exercises/detailed/:id', dataCall: DB.Exercises.getDetailed, apiMethod: "getByParam", param: "id" },
    { path: '/api/exercises', dataCall: DB.Manage.storeExercise, apiMethod: "putByBodyParam", param: "exercise" },

    { path: '/api/tutors', dataCall: DB.Manage.listTutors, apiMethod: "get"},
    { path: '/api/tutors', dataCall: DB.Manage.storeTutor, apiMethod: "putByBodyParam", param: "tutor"},

    { path: '/api/groups', dataCall: DB.Manage.listGroups, apiMethod: "get" },

    { path: '/api/users', dataCall: DB.Manage.listUsers, apiMethod: "get"},

  ];
};
