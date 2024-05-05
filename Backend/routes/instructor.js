const express = require('express');
const instructor = require('../controllers/instructor');

const router = express.Router();

router
  .get('/', instructor.onGetAllInstructors)
  .post('/', instructor.onCreateInstructor)
  .get('/:id', instructor.onGetInstructorByID)
  .delete('/:id', instructor.onDeleteInstructorByID)
  .patch('/:id', instructor.onEditInstructorByID)
  .post("/give-attendance", instructor.onGiveAttendance);

module.exports = router;
