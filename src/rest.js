
module.exports = function(DB){
  return [
    { path: '/api/exercises', dataCall: DB.Exercises.get, apiMethod: "get" },
    
  ];
};
