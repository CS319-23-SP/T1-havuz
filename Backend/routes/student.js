const express = require('express');
const student = require('../controllers/student');

const router = express.Router();

router
  .get('/', student.onGetAllStudents)
  .post('/', student.onCreateStudent)
  .get('/:id', student.onGetStudentByID)
  .delete('/:id', student.onDeleteStudentByID)
  .patch('/:id', student.onEditStudentByID)
  .get("/attendance/:studentID", student.onGetStudentAttendance);

module.exports = router;