const express = require('express');
const assignment = require('../controllers/assignment');

const router = express.Router();

router
  .get('/', assignment.onGetAssignments)
  .post('/', assignment.onCreateAssignment)
  .get('/:id/:term/:sectionID', assignment.onGetAssignment)
  .delete('/:id/:term/:sectionID', assignment.onDeleteAssignment)
  .patch('/:id/:term/:sectionID', assignment.onEditAssignment);

module.exports = router;