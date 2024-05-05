const express = require('express');
const section = require('../controllers/section');

const router = express.Router();

router
  .get('/', section.onGetSections)
  .post('/', section.onCreateSection)
  .get('/:id/:term/:courseID', section.onGetSection)
  .get('/:id/:term', section.onGetSectionByIDAndTerm)
  .delete('/:id/:term/:courseID', section.onDeleteSection)
  .patch('/:id/:term/:courseID', section.onEditSection)
  .get('/sections/:sectionID/students', section.onGetStudentsBySectionID);

module.exports = router;