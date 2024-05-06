const express = require('express');
const student = require('../controllers/student');
const roleChecker = require('../middlewares/roleChecker');

const router = express.Router();

router
  .get('/', roleChecker(['admin']), student.onGetAllStudents)
  .post('/', roleChecker(['admin']), student.onCreateStudent)
  .get('/:id', student.onGetStudentByID)
  .get("/attendance/:studentID", student.onGetStudentAttendance);
  .delete('/:id', roleChecker(['admin']), student.onDeleteStudentByID)
  .patch('/:id', roleChecker(['admin', 'student']), student.onEditStudentByID);

module.exports = router;