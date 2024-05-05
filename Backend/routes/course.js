const express = require('express');
const course = require('../controllers/course');
const roleChecker = require('../middlewares/roleChecker');

const router = express.Router();

router
  .get('/', course.onGetCourses)
  .post('/', roleChecker(['admin']), course.onCreateCourse)
  .get('/:id', course.onGetCourseByID)
  .get('/term/:term', course.onGetCourseByTerm)
  .get('/:id/:term', course.onGetCourseByIDAndTerm)
  .delete('/:id/:term', roleChecker(['admin']), course.onDeleteCourseByIDAndTerm)
  .patch('/:id/:term', roleChecker(['admin', 'instructor']), course.onEditCourseByIDAndTerm);

module.exports = router;