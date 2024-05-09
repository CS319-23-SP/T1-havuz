const express = require('express');
const assignment = require('../controllers/assignment');
const roleChecker = require('../middlewares/roleChecker');

const router = express.Router();

router
  .get('/', assignment.onGetAssignments)
  .post('/', roleChecker(['admin', 'instructor']), assignment.onCreateAssignment)
  .get('/instructor/:term/:sectionID', assignment.onGetAssignmentForInstructor)
  .get('/:id/:term/:sectionID', assignment.onGetAssignment)
  .delete('/:id/:term/:sectionID', roleChecker(['admin', 'instructor']), assignment.onDeleteAssignment)
  .patch('/:id/:term/:sectionID', roleChecker(['admin', 'instructor']), assignment.onEditAssignment)
  .put('/:id/:term/:sectionID/:studentID', roleChecker(['admin', 'instructor']), assignment.onUpdateAssGrade);
  
  module.exports = router;