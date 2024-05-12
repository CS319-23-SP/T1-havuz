const express = require('express');
const instructor = require('../controllers/instructor');
const roleChecker = require('../middlewares/roleChecker');

const router = express.Router();

router
  .get('/', roleChecker(['admin']), instructor.onGetAllInstructors)
  .post('/', roleChecker(['admin']), instructor.onCreateInstructor)
  .get('/:id', instructor.onGetInstructorByID)
  .post("/give-attendance/:term", instructor.onGiveAttendance)
  .post("/attendance", roleChecker(['admin', 'instructor']), instructor.onGetAttendance)
  .delete('/:id', roleChecker(['admin']), instructor.onDeleteInstructorByID)
  .patch('/:id', roleChecker(['admin', 'instructor']), instructor.onEditInstructorByID);

module.exports = router;
