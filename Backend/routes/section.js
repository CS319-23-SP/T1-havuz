const express = require('express');
const section = require('../controllers/section');
const roleChecker = require('../middlewares/roleChecker');

const router = express.Router();

router
  .get('/', roleChecker(['admin', 'instructor']), section.onGetSections)
  .post('/', roleChecker(['admin', 'instructor']), section.onCreateSection)
  .get('/:id/:term/:courseID', section.onGetSection)
  .get('/:id/:term', section.onGetSectionByIDAndTerm)
  .get('/sections/:sectionID/students', section.onGetStudentsBySectionID);
  .delete('/:id/:term/:courseID', roleChecker(['admin', 'instructor']), section.onDeleteSection)
  .patch('/:id/:term/:courseID', roleChecker(['admin', 'instructor']), section.onEditSection);

module.exports = router;