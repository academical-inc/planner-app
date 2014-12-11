
BaseModel = require './BaseModel'


class Student extends BaseModel

  urlRoot: "students"


class StudentStore

  @init: (studentId, {success, error}={})->
    # Need to get this from login
    student = new Student id: studentId
    student.fetch
      success: (model)=>
        @_student = student
        success @_student
      error: error

  @get: (attr)->
    @_student.get attr if @_student?


module.exports = StudentStore
