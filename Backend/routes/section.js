const express = require('express');
const section = require('../controllers/section');

const router = express.Router();

router
  .get('/', section.onGetSections)
  .post('/', section.onCreateSection)
  .get('/:id/:term/:courseID', section.onGetSection)
  .delete('/:id/:term/:courseID', section.onDeleteSection)
  .patch('/:id/:term/:courseID', section.onEditSection);

module.exports = router;