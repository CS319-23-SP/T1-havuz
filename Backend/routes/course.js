const express = require('express');
const course = require('../controllers/course');

const router = express.Router();

router
  .get('/', course.onGetCourses)
  .post('/', course.onCreateCourse)
  .get('/:id', course.onGetCourseByID)
  .get('/term/:term', course.onGetCourseByTerm)
  .get('/:id/:term', course.onGetCourseByIDAndTerm)
  .delete('/:id/:term', course.onDeleteCourseByIDAndTerm)
  .patch('/:id/:term', course.onEditCourseByIDAndTerm);

module.exports = router;